extends Weapon

@export var slash: PackedScene

func _process(delta: float) -> void:
	super(delta)

func attack(origin_position: Vector2, target_position: Vector2) -> void:
	if since_last_attack < weapon_cooldown:
		return
	since_last_attack = 0
	var angle: float = origin_position.angle_to_point(target_position)
	var slash_instance: Attack = slash.instantiate()
	slash_instance.collision_layer = weapon_owner.collision_layer
	slash_instance.collision_mask = weapon_owner.collision_mask
	slash_instance.rotation = angle
	slash_instance.damage = damage
	
	if target_position.x - origin_position.x < 0:
		slash_instance.sprite.play("Slash_Left")
	else:
		slash_instance.sprite.play("Slash_Right")
		
	add_child(slash_instance)
