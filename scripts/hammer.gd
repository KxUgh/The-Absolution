extends Weapon

@export var hammer_hit: PackedScene

func attack(origin_position: Vector2, target_position: Vector2) -> void:
	var angle: float = origin_position.angle_to_point(target_position)
	var hammer_hit_instance: Attack = init_attack(hammer_hit)
	hammer_hit_instance.rotation = angle
	
	if target_position.x - origin_position.x < 0:
		hammer_hit_instance.sprite.play("Hit_Left")
	else:
		hammer_hit_instance.sprite.play("Hit_Right")
		
	add_child(hammer_hit_instance)
