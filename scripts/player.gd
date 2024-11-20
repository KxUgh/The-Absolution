class_name Player
extends Entity

enum State{
	IDLE,
	MOVING,
	ATTACKING,
	BLOCKING,
	HIT,
	DEAD_INQUISITION,
	DEAD_MONSTER,
}

signal health_changed()

@export var sprite: AnimatedSprite2D
@export var weapon: Weapon
@export var attack_cooldown: float
@export var attack_duration: float
@export var block_cooldown: float
@export var block_duration: float
@export var hit_duration: float

@onready var player_data: PlayerData = Common.load_player_data()
@onready var since_last_attack: float = attack_cooldown
@onready var since_last_block: float = block_cooldown
@onready var since_last_hit: float = hit_duration
@onready var state: State = State.IDLE

func _ready() -> void:
	player_data.health = player_data.max_health
	weapon.damage = player_data.damage

func _physics_process(delta: float) -> void:
	since_last_attack += delta
	since_last_block += delta
	since_last_hit += delta

	# Get movement input from player
	# -1 <= x_direction, ydirection <= 1
	var x_direction: float = Input.get_axis("left", "right")
	var y_direction: float = Input.get_axis("up", "down")
	var direction: Vector2 = Vector2(x_direction,y_direction).normalized()
	velocity = player_data.speed * direction
	
	var previous_state: State = state
	state = determine_state()
	process_state(previous_state)

func determine_state() -> State:
	if state == State.DEAD_INQUISITION:
		return State.DEAD_INQUISITION
	
	if state == State.DEAD_MONSTER:
		return State.DEAD_MONSTER
	
	if since_last_hit < hit_duration and state == State.HIT:
		return State.HIT

	if (Input.is_action_just_pressed("attack") and can_attack()) or (since_last_attack < attack_duration and state == State.ATTACKING):
		return State.ATTACKING
	
	if (Input.is_action_just_pressed("block") and can_block()) or (since_last_block < block_duration and state == State.BLOCKING):
		return State.BLOCKING
	
	if velocity.length() > 0.0001:
		return State.MOVING
	
	return State.IDLE
	
func process_state(previous_state: State) -> void:
	match state:
		State.IDLE:
			move_and_slide()
			sprite.play("Idle")
		State.ATTACKING:
			move_and_slide()
			if previous_state != state:
				since_last_attack = 0
				var mouse_position: Vector2 = get_global_mouse_position()
				if mouse_position.x - position.x < 0:
					Common.play_sprite_animation_duration(sprite, "Attack_Left", attack_duration)
				else:
					Common.play_sprite_animation_duration(sprite, "Attack_Right", attack_duration)
				weapon.attack(position,mouse_position)
		State.BLOCKING:
			if previous_state != state:
				since_last_block = 0
				var mouse_position: Vector2 = get_global_mouse_position()
				if mouse_position.x - position.x < 0:
					Common.play_sprite_animation_duration(sprite, "Block_Left", block_duration)
				else:
					Common.play_sprite_animation_duration(sprite, "Block_Right", block_duration)
		State.MOVING:
			move_and_slide()
			if velocity.x > 0:
				sprite.play("Right")
			else:
				sprite.play("Left")
		State.HIT:
			move_and_slide()
			Common.play_sprite_animation_duration(sprite, "Hit", hit_duration)
		State.DEAD_INQUISITION:
			if sprite.animation != "Death_Inquisition":
				sprite.play("Death_Inquisition")
		State.DEAD_MONSTER:
			if sprite.animation != "Death_Monster":
				sprite.play("Death_Monster")
		

func can_attack() -> bool:
	return since_last_attack > attack_cooldown

func can_block() -> bool:
	return since_last_block > block_cooldown

func take_damage(damage: float, type: Entity_type) -> void:
	if state in [State.HIT,State.DEAD_INQUISITION,State.DEAD_MONSTER]:
		return
	if state == State.BLOCKING and damage < 1000:
		return
	state = State.HIT
	since_last_hit = 0
	player_data.health -= damage
	player_data.health = clampf(player_data.health,0,player_data.max_health)
	health_changed.emit()
	if player_data.health == 0:
		die(type)

func die(type: Entity_type) -> void:
	Common.save_player_data(player_data)
	match type:
		Entity.Entity_type.MONSTER:
			state = State.DEAD_MONSTER
		Entity_type.INQUISITION:
			state = State.DEAD_INQUISITION
