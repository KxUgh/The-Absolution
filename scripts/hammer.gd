extends Weapon

@export var hammer_hit: PackedScene

func _process(delta: float) -> void:
	super(delta)

func attack(origin_position: Vector2, target_position: Vector2) -> void:
	if since_last_attack < weapon_cooldown:
		return
	since_last_attack = 0
	var angle: float = origin_position.angle_to_point(target_position)
	var hammer_hit_instance: Attack = hammer_hit.instantiate()
	hammer_hit_instance.collision_layer = weapon_owner.collision_layer
	hammer_hit_instance.collision_mask = weapon_owner.collision_mask
	hammer_hit_instance.rotation = angle
	hammer_hit_instance.damage = damage
	
	if target_position.x - origin_position.x < 0:
		hammer_hit_instance.sprite.play("Hit_Left")
	else:
		hammer_hit_instance.sprite.play("Hit_Right")
		
	add_child(hammer_hit_instance)
