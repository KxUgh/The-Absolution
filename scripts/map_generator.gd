extends Node2D

@export var width: int
@export var height: int
@export var block_width: float
@export var block_height: float
@export var blocks: Array[PackedScene]
@export var start_block: PackedScene

@onready var rng = RandomNumberGenerator.new()

func _ready() -> void:
	seed(rng.randi())
	for i in range(-height/2,height/2 + 1):
		for j in range(-width/2,width/2 + 1):
			var block_instance: Node2D
			if i == 0 and j == 0:
				block_instance = start_block.instantiate()
			else:
				block_instance = blocks.pick_random().instantiate()
			block_instance.position.x = j*block_width
			block_instance.position.y = i*block_height
			add_child(block_instance)
