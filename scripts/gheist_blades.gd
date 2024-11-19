extends Weapon

@export var flurry_attack: PackedScene

func attack(origin_position: Vector2, target_position: Vector2) -> void:
	var angle: float = origin_position.angle_to_point(target_position)
	var flurry_attack_instance: Attack = init_attack(flurry_attack)
	flurry_attack_instance.rotation = angle
	add_child(flurry_attack_instance)
