extends CharacterBody2D

@export var speed: float
@export var acceleration: float
@export var weapon: Weapon
@export var attack_cooldown: float

@onready var since_last_attack: float = 0
@onready var animations = $AnimatedSprite

func _physics_process(delta: float) -> void:
	since_last_attack += delta
	
	# Get movement input from player
	# -1 <= x_direction, ydirection <= 1
	var x_direction: float = Input.get_axis("left", "right")
	var y_direction: float = Input.get_axis("up", "down")
	
	var direction: Vector2 = Vector2(x_direction,y_direction).normalized()
	velocity = lerp(velocity,speed * direction, acceleration * delta)
	
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		
		var mouse_position: Vector2 = get_global_mouse_position()
		
		if mouse_position.x < 0:
			animations.play("Attack_Left")
		else:
			animations.play("Attack_Right")
		
		weapon.attack(position,mouse_position)
		
	var directionAnim = "Idle"
	
	if x_direction < 0: 
		directionAnim = "Left"
	elif x_direction == 0 and y_direction == 0: 
		directionAnim = "Idle"
	else: 
		directionAnim = "Right"
	
	animations.play(directionAnim)
