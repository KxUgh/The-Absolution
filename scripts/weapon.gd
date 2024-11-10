# A virtual class which allows for a modular weapon system

class_name Weapon
extends Node2D

@export var weapon_cooldown: float

var since_last_attack: float = 0

func attack(_origin_position: Vector2, _target_position: Vector2) -> void:
	pass
