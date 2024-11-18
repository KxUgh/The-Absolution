extends Enemy

@export var nav_agent: NavigationAgent2D
@export var weapon: Weapon
@export var attack_cooldown: float
@export var sprite: AnimatedSprite2D

@onready var since_last_attack = attack_cooldown

var target: Node2D

func _process(_delta: float) -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players:
		target = players[0]

func _physics_process(delta: float) -> void:
	since_last_attack += delta
	
	var direction: Vector2 = get_navigation_direction()
	
	if get_distance_to_target() > 30:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		if can_attack():
			if target.position.x - position.x < 0:
				sprite.play("Attack_Left")
			else:
				sprite.play("Attack_Right")
			weapon.attack(position,target.position)
			since_last_attack = 0
	move_and_slide()

func get_navigation_direction() -> Vector2:
	if not target:
		return Vector2.ZERO
	nav_agent.target_position = target.position
	if nav_agent.is_navigation_finished():
		return Vector2.ZERO
	var next_position: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2 = position.direction_to(next_position)
	return direction

func get_distance_to_target() -> float:
	if target:
		return (target.position - position).length()
	return INF
	
func take_damage(damage: float, _type: Entity_type) -> void:
	health -= damage
	health = clampf(health,0,max_health)
	if health == 0:
		die()

func die() -> void:
	sprite.play("Death")
	queue_free()
	
func can_attack() -> bool:
	return since_last_attack > attack_cooldown
	
