extends TextureProgressBar

@export var player: Player

func _ready() -> void:
	player.health_changed.connect(update)
	update()
	
func update() -> void:
	value = player.player_data.health * 100 / player.player_data.max_health
