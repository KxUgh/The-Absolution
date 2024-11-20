extends Weapon

@export var inner_attack: PackedScene
@export var outer_attack: PackedScene

func attack(origin_position: Vector2, target_position: Vector2) -> void:
	var inner_attack_instance: Attack = init_attack(inner_attack)
	var outer_attack_instance: Attack = init_attack(outer_attack)
	outer_attack_instance.damage *= 0.5
	add_child(inner_attack_instance)
	add_child(outer_attack_instance)
