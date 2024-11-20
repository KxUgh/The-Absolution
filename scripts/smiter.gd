extends Weapon

@export var smite: PackedScene

func attack(origin_position: Vector2, target_position: Vector2) -> void:
	var angle: float = origin_position.angle_to_point(target_position)
	var smite_instance: Attack = init_attack(smite)
	smite_instance.global_position = target_position
	get_node("/root/Node2D").add_child(smite_instance)
