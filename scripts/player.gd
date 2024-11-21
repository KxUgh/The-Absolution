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
@export var blight_weapon: Weapon
@export var attack_cooldown: float
@export var attack_duration: float
@export var block_cooldown: float
@export var block_duration: float
@export var hit_duration: float
@export var blight_attack_cooldown: float

@onready var player_data: PlayerData = Common.load_player_data()
@onready var since_last_attack: float = attack_cooldown
@onready var since_last_block: float = block_cooldown
@onready var since_last_hit: float = hit_duration
@onready var since_last_blight_attack: float = blight_attack_cooldown
@onready var state: State = State.IDLE
@onready var death_screen: PackedScene = load("res://scenes/death_screen.tscn")
@onready var previous_buff = player_data.buff

func _ready() -> void:
	player_data.health = player_data.max_health
	weapon.damage = player_data.damage
	blight_weapon.damage = player_data.damage / 2

func _physics_process(delta: float) -> void:
	since_last_attack += delta
	since_last_block += delta
	since_last_hit += delta
	since_last_blight_attack += delta

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
				if player_data.buff == PlayerData.BuffType.BLIGHT and since_last_blight_attack > blight_attack_cooldown:
					since_last_blight_attack = 0
					blight_weapon.attack(position,mouse_position)
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
			if not sprite.is_playing():
				get_tree().change_scene_to_packed(death_screen)
		State.DEAD_MONSTER:
			if sprite.animation != "Death_Monster":
				sprite.play("Death_Monster")
			if not sprite.is_playing():
				if player_data.buff != previous_buff:
					player_data.health = player_data.max_health
					health_changed.emit()
					state = State.IDLE
				else:
					get_tree().change_scene_to_packed(death_screen)
		

func can_attack() -> bool:
	return since_last_attack > attack_cooldown

func can_block() -> bool:
	return since_last_block > block_cooldown

func take_damage(damage: float, type: Entity_type, buff: PlayerData.BuffType = PlayerData.BuffType.NONE) -> void:
	if state in [State.HIT,State.DEAD_INQUISITION,State.DEAD_MONSTER]:
		return
	if state == State.BLOCKING and damage < 1000:
		return
	state = State.HIT
	since_last_hit = 0
	var last_health: float = player_data.health
	player_data.health -= damage
	if player_data.buff == PlayerData.BuffType.ZOMBIE and last_health > 1:
		player_data.health = clampf(player_data.health,1,player_data.max_health)
	else:
		player_data.health = clampf(player_data.health,0,player_data.max_health)
	health_changed.emit()
	if player_data.health == 0:
		die(type, buff)

func die(type: Entity_type, buff: PlayerData.BuffType) -> void:
	previous_buff = player_data.buff
	player_data.buff = buff
	Common.save_player_data(player_data)
	match type:
		Entity.Entity_type.MONSTER:
			state = State.DEAD_MONSTER
		Entity_type.INQUISITION:
			state = State.DEAD_INQUISITION

func apply_potion_effect(type: Potion.PotionType,value: float) -> void:
	match type:
		Potion.PotionType.HEALTH:
			player_data.max_health += value
		Potion.PotionType.DAMAGE:
			player_data.damage += value
