extends Weapon

@export var claw_attack: PackedScene

func attack(origin_position: Vector2, target_position: Vector2) -> void:
	var angle: float = origin_position.angle_to_point(target_position)
	var claw_attack_instance: Attack = init_attack(claw_attack)
	claw_attack_instance.rotation = angle
	add_child(claw_attack_instance)
