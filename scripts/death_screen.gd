extends Control

@export var restart_button: Button
@export var exit_button: Button
@export var menu_button: Button

@onready var game: PackedScene = load("res://scenes/main.tscn")
@onready var menu: PackedScene = load("res://scenes/main_menu.tscn")

func _ready() -> void:
	Music.set_music(Music.MusicType.GAME)
	restart_button.pressed.connect(restart_game)
	exit_button.pressed.connect(exit)
	menu_button.pressed.connect(go_to_menu)

func _process(delta: float) -> void:
	pass
	
func restart_game() -> void:
	get_tree().change_scene_to_packed(game)
	
func exit() -> void:
	get_tree().quit()

func go_to_menu() -> void:
	get_tree().change_scene_to_packed(menu)
