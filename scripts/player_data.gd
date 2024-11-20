class_name PlayerData
extends Resource

enum BuffType{
	NONE,
}

@export var max_health: float = 10
@export var speed: float = 100
@export var damage: float = 3
@export var health: float
@export var buff: BuffType
