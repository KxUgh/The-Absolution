class_name Player
extends Entity

signal health_changed()

@export var sprite: AnimatedSprite2D
@export var base_speed: float
@export var acceleration: float
@export var weapon: Weapon
@export var attack_cooldown: float
@export var block_cooldown: float

@onready var since_last_attack: float = attack_cooldown
@onready var since_last_block: float = block_cooldown
@onready var speed: float = base_speed
@onready var invulnerable: bool = false
@onready var dead: bool = false

func _ready() -> void:
	sprite.animation_changed.connect(_on_animation_changed)

func _physics_process(delta: float) -> void:
	if dead:
		return
	since_last_attack += delta
	since_last_block += delta
	
	
	# Get movement input from player
	# -1 <= x_direction, ydirection <= 1
	var x_direction: float = Input.get_axis("left", "right")
	var y_direction: float = Input.get_axis("up", "down")
	var direction: Vector2 = Vector2(x_direction,y_direction).normalized()
	velocity = lerp(velocity,speed * direction, acceleration * delta)
	
	move_and_slide()

	if Input.is_action_just_pressed("attack") and can_attack():
		since_last_attack = 0
		var mouse_position: Vector2 = get_global_mouse_position()
		if mouse_position.x - position.x < 0:
			sprite.play("Attack_Left")
		else:
			sprite.play("Attack_Right")
		weapon.attack(position,mouse_position)
	
	if Input.is_action_just_pressed("block") and can_block():
		since_last_block = 0
		var mouse_position: Vector2 = get_global_mouse_position()
		if mouse_position.x - position.x < 0:
			sprite.play("Block_Left")
		else:
			sprite.play("Block_Right")
	
	var directionAnim = "Idle"
	
	if x_direction < 0: 
		directionAnim = "Left"
	elif x_direction == 0 and y_direction == 0: 
		directionAnim = "Idle"
	else: 
		directionAnim = "Right"
	
	var direction_anims: Array[String] = ["Idle","Left","Right"]
	if sprite.animation in direction_anims or not sprite.is_playing():
		sprite.play(directionAnim)
		
func can_attack() -> bool:
	var eligible_states: Array[String] = ["Idle","Left","Right"]
	return since_last_attack > attack_cooldown and sprite.animation in eligible_states

func can_block() -> bool:
	var eligible_states: Array[String] = ["Idle","Left","Right"]
	return since_last_block > block_cooldown and sprite.animation in eligible_states

func take_damage(damage: float, type: Entity_type) -> void:
	if invulnerable:
		return
	sprite.play("Hit")
	health -= damage
	health = clampf(health,0,max_health)
	health_changed.emit()
	if health == 0:
		die(type)

func die(type: Entity_type) -> void:
	dead = true
	match type:
		Entity.Entity_type.MONSTER:
			sprite.play("Death_Monster")
		Entity_type.INQUISITION:
			sprite.play("Death_Inquisition")

func _on_animation_changed() -> void:
	calculate_speed()
	determine_invulnerable()
	
func calculate_speed() -> void:
	var current_animation: String = sprite.animation
	match current_animation:
		"Block_Left","Block_Right","Death_Monster","Death_Inquisition":
			speed = 0
			return
		_:
			speed = base_speed
			return

func determine_invulnerable() -> void:
	var current_animation: String = sprite.animation
	match  current_animation:
		"Hit","Block_Left","Block_Right","Death_Monster","Death_Inquisition":
			invulnerable = true
			return
		_:
			invulnerable = false
			return
	
