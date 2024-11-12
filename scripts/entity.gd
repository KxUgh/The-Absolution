class_name Entity
extends CharacterBody2D

@export var max_health: float
@onready var health: float = max_health

func take_damage(float) -> void:
	pass
