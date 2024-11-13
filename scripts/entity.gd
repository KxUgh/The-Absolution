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

func take_damage(_damage: float, _entity_type: Entity_type) -> void:
	pass
