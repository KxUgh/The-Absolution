extends Enemy

enum State{
	IDLE,
	MOVING,
	CHANNELING,
	ATTACKING,
	DISAPPEARING,
	APPEARING,
	DEAD,
}
@export var nav_agent: NavigationAgent2D
@export var nav_timer: Timer
@export var weapon: Weapon
@export var sprite: AnimatedSprite2D
@export var teleport_distance: float
@export var attack_cooldown: float
@export var channeling_duration: float
@export var attack_duration: float
@export var hit_cooldown: float
@export var disappear_duration: float
@export var appear_duration: float
@onready var since_last_attack = attack_cooldown
@onready var since_last_hit = hit_cooldown
@onready var since_last_disappear = disappear_duration
@onready var state = State.IDLE

var target: Node2D
var attack_position: Vector2

func _ready() -> void:
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	nav_timer.timeout.connect(update_nav_agent)

func _physics_process(delta: float) -> void:
	since_last_attack += delta
	since_last_hit += delta
	since_last_disappear += delta
	
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2 = position.direction_to(next_path_position)
	
	nav_agent.set_velocity(direction * speed)
	
	var previous_state: State = state
	state = determine_state()
	process_state(previous_state)

	
func determine_state() -> State:
	if state == State.DEAD:
		return State.DEAD
	
	if state in [State.DISAPPEARING, State.APPEARING] and disappear_duration < since_last_disappear and since_last_disappear < disappear_duration + appear_duration:
		return State.APPEARING
	
	if state in [State.ATTACKING, State.DISAPPEARING] and since_last_disappear < disappear_duration:
		return State.DISAPPEARING
		
	if state in [State.CHANNELING, State.ATTACKING] and channeling_duration < since_last_attack and since_last_attack < attack_duration + channeling_duration:
		return State.ATTACKING

	if (get_distance_to_target() < 30 and can_attack()) or (since_last_attack < channeling_duration and state == State.CHANNELING):
		return State.CHANNELING

	if velocity.length() > 0.0001:
		return State.MOVING
	
	return State.IDLE

func process_state(previous_state: State) -> void:
	match state:
		State.IDLE:
			move_and_slide()
			sprite.play("Idle")
			
		State.CHANNELING:
			if previous_state != state:
				since_last_attack = 0
				attack_position = target.position
				if attack_position.x - position.x < 0:
					Common.play_sprite_animation_duration(sprite, "Channel_Attack_Left", channeling_duration)
				else:
					Common.play_sprite_animation_duration(sprite, "Channel_Attack_Right", channeling_duration)
		State.ATTACKING:
			if previous_state != state:
				if attack_position.x - position.x < 0:
					Common.play_sprite_animation_duration(sprite, "Attack_Left", attack_duration)
				else:
					Common.play_sprite_animation_duration(sprite, "Attack_Right", attack_duration)
				weapon.attack(position,attack_position)
			if sprite.frame_progress > 0.9 and sprite.frame == 2:
				since_last_disappear = 0
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
		State.DISAPPEARING:
			if previous_state != state:
				since_last_disappear = 0
				Common.play_sprite_animation_duration(sprite, "Disappear", disappear_duration)
		State.APPEARING:
			if previous_state != state:
				Common.play_sprite_animation_duration(sprite, "Appear", appear_duration)
				var distance: float
				position += attack_position.direction_to(position) * teleport_distance


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
	if state in [State.DEAD] or since_last_hit < hit_cooldown:
		return
	since_last_hit = 0
	health -= damage
	health = clampf(health,0,max_health)
	if health == 0:
		die()

func die() -> void:
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