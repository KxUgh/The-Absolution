class_name Potion
extends Area2D

enum PotionType{
	HEALTH,
	DAMAGE,
	SPEED,
}

@export var type: PotionType
@export var value: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.apply_potion_effect(type,value)
		queue_free()
