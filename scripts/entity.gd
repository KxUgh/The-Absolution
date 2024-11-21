class_name Entity
extends CharacterBody2D

enum Entity_type{
	PLAYER,
	MONSTER,
	INQUISITION,
}

@export var entity_type: Entity_type
@export var max_health: float
@onready var health: float = max_health

func take_damage(_damage: float, _entity_type: Entity_type, buff: PlayerData.BuffType = PlayerData.BuffType.NONE) -> void:
	pass
	
func get_potion_probability() -> float:
	match entity_type:
		Entity_type.MONSTER:
			return 0.05
		Entity_type.INQUISITION:
			return 0.1
	return 0
