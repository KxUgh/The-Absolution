class_name Player
extends Entity

@export var base_speed: float
@export var acceleration: float
@export var weapon: Weapon
@export var attack_cooldown: float

@onready var since_last_attack: float = 0
@onready var since_last_block: float = 0
@onready var animations = $AnimatedSprite

func _physics_process(delta: float) -> void:
	var speed: float = calculate_speed()
	
	since_last_attack += delta
	since_last_block += delta
	
	# Get movement input from player
	# -1 <= x_direction, ydirection <= 1
	var x_direction: float = Input.get_axis("left", "right")
	var y_direction: float = Input.get_axis("up", "down")
	var direction: Vector2 = Vector2(x_direction,y_direction).normalized()
	velocity = lerp(velocity,speed * direction, acceleration * delta)
	
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		
		var mouse_position: Vector2 = get_global_mouse_position()
		if since_last_attack >= weapon.weapon_cooldown:
			if mouse_position.x - position.x < 0:
				animations.play("Attack_Left")
			else:
				animations.play("Attack_Right")
			weapon.attack(position,mouse_position)
			since_last_attack = 0
	
	if Input.is_action_just_pressed("block"):
		
		var mouse_position: Vector2 = get_global_mouse_position()
		if since_last_block >= 1.5:
			if mouse_position.x - position.x < 0:
				animations.play("Block_Left")
			else:
				animations.play("Block_Right")
			since_last_block = 0
	
	var directionAnim = "Idle"
	
	if x_direction < 0: 
		directionAnim = "Left"
	elif x_direction == 0 and y_direction == 0: 
		directionAnim = "Idle"
	else: 
		directionAnim = "Right"
	
	var specAnimList = ["Attack_Left", "Attack_Right", "Block_Left", "Block_Right"]
	if animations.animation not in specAnimList or not animations.is_playing():
		animations.play(directionAnim)
		
func calculate_speed() -> float:
	var current_animation: String = animations.animation
	match current_animation:
		"Block_Left","Block_Right":
			return 0
		_:
			return base_speed
