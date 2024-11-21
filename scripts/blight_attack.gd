extends Attack

@export var sprite: AnimatedSprite2D

func _ready() -> void:
	super()
	sprite.frame = 0

func _process(_delta: float) -> void:
	if not sprite.is_playing():
		queue_free()
	monitoring = (sprite.frame == 2)
