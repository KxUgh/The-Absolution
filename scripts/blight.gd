extends Enemy

enum State{
	IDLE,
	MOVING,
	ATTACKING,
	DEAD,
}

@export var potions: Array[PackedScene]
@export var nav_agent: NavigationAgent2D
@export var nav_timer: Timer
@export var weapon: Weapon
@export var sprite: AnimatedSprite2D
@export var attack_cooldown: float
@export var attack_duration: float
@export var hit_cooldown: float

@onready var since_last_attack = attack_cooldown
@onready var since_last_hit = hit_cooldown
@onready var state = State.IDLE

var target: Node2D
var attack_position: Vector2

func _ready() -> void:
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	nav_timer.timeout.connect(update_nav_agent)

func _physics_process(delta: float) -> void:
	since_last_attack += delta
	since_last_hit += delta
	
	if get_distance_to_target() > 150:
		return
	
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_path_position)
	
	nav_agent.set_velocity(direction * speed)
	
	var previous_state: State = state
	state = determine_state()
	process_state(previous_state)

	
func determine_state() -> State:
	if state == State.DEAD:
		return State.DEAD
		

	if (get_distance_to_target() < 70 and can_attack()) or (since_last_attack < attack_duration and state == State.ATTACKING):
		return State.ATTACKING

	if velocity.length() > 0.0001:
		return State.MOVING
	
	return State.IDLE

func process_state(previous_state: State) -> void:
	match state:
		State.IDLE:
			move_and_slide()
			sprite.play("Idle")
			
		State.ATTACKING:
			if previous_state != state:
				since_last_attack = 0
				Common.play_sprite_animation_duration(sprite, "Attack", attack_duration)
				weapon.attack(position,target.position)
		State.MOVING:
			move_and_slide()
			if velocity.x > 0:
				sprite.play("Right")
			else:
				sprite.play("Left")
		State.DEAD:
			if sprite.animation != "Death":
				sprite.play("Death")
			if not sprite.is_playing():
				queue_free()



func get_navigation_direction() -> Vector2:
	if not target:
		return Vector2.ZERO
	nav_agent.target_position = target.global_position
	if nav_agent.is_navigation_finished():
		return Vector2.ZERO
	var next_position: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2 = position.direction_to(next_position)
	return direction

func get_distance_to_target() -> float:
	if target:
		return (target.global_position - global_position).length()
	return INF
	
func take_damage(damage: float, _type: Entity_type, _buff: PlayerData.BuffType = PlayerData.BuffType.NONE) -> void:
	if state in [State.DEAD] or since_last_hit < hit_cooldown:
		return
	since_last_hit = 0
	var previous_health: float = health
	health -= damage
	health = clampf(health,0,max_health)
	if health == 0:
		die()

func die() -> void:
	if RandomNumberGenerator.new().randf() < get_potion_probability():
		var potion: Potion = potions.pick_random().instantiate()
		potion.position = position
		get_node("/root/Node2D").add_child(potion)
	state = State.DEAD
	
func can_attack() -> bool:
	return since_last_attack > attack_cooldown
	
func find_target() -> void:
	var players = get_tree().get_nodes_in_group("Players")
	if len(players) > 0:
		target = players[0]
		
func update_nav_agent() -> void:
	find_target()
	nav_agent.target_position = target.position

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
