class_name Attack
extends Area2D

var damage: float
var entity_type: Entity.Entity_type

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.take_damage(damage,entity_type)
	
