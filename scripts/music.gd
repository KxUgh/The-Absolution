extends AudioStreamPlayer

enum MusicType{
	NONE,
	MENU,
	GAME,
}

@export var menu_music: AudioStream
@export var game_music: AudioStream

@onready var type: MusicType = MusicType.NONE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(reset_music)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset_music() -> void:
	play()
	
func set_music(music: MusicType) -> void:
	if music == type:
		return
	type = music
	match music:
		MusicType.MENU:
			stream = menu_music
		MusicType.GAME:
			stream = game_music
	reset_music()
