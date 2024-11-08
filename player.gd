extends CharacterBody2D

@export var speed: float
@export var acceleration: float

func _physics_process(delta: float) -> void:
	
	# Get movement input from player
	# -1 <= x_direction, ydirection <= 1
	var x_direction: float = Input.get_axis("left", "right")
	var y_direction: float = Input.get_axis("up", "down")
	
	velocity.x = lerp(velocity.x,speed * x_direction,acceleration * delta)
	velocity.y = lerp(velocity.y,speed * y_direction,acceleration * delta)

	move_and_slide()
