extends Label

@export var player: Player

func _process(delta: float) -> void:
	text = "Buff: [" + buff_to_text(player.player_data.buff) + "]"


func buff_to_text(buff: PlayerData.BuffType) -> String:
	match buff:
		PlayerData.BuffType.NONE:
			return "None"
		PlayerData.BuffType.ZOMBIE:
			return "Zombie"
		PlayerData.BuffType.BLIGHT:
			return "Blight"
	return "IDK"
