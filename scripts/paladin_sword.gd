extends Weapon

@export var paladin_sword_slash: PackedScene

func attack(origin_position: Vector2, target_position: Vector2) -> void:
	var angle: float = origin_position.angle_to_point(target_position)
	var paladin_sword_slash_instance: Attack = init_attack(paladin_sword_slash)
	paladin_sword_slash_instance.rotation = angle
	add_child(paladin_sword_slash_instance)
