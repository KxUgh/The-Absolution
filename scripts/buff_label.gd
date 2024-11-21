extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Current buff: [" + buff_to_text(Common.load_player_data().buff) + "]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func buff_to_text(buff: PlayerData.BuffType) -> String:
	match buff:
		PlayerData.BuffType.NONE:
			return "None"
		PlayerData.BuffType.ZOMBIE:
			return "Zombie"
		PlayerData.BuffType.BLIGHT:
			return "Blight"
	return "IDK"
