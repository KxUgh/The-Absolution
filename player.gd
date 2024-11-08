extends CharacterBody2D

@export var speed: float
@export var acceleration: float

func _physics_process(delta: float) -> void:
	
	# Get movement input from player
	# -1 <= xDirection, yDirection <= 1
	var xDirection: float = Input.get_axis("left", "right")
	var yDirection: float = Input.get_axis("up", "down")
	
	velocity.x = lerp(velocity.x,speed * xDirection,acceleration * delta)
	velocity.y = lerp(velocity.y,speed * yDirection,acceleration * delta)

	move_and_slide()
