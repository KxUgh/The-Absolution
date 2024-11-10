extends Camera2D

@export var player: Node2D
@export var stiffness: float

func _physics_process(delta: float) -> void:
	position += (player.position - position) * stiffness * delta
