class_name MainMenu
extends Control

@export var start_button: Button
@export var options_button: Button
@export var exit_button: Button
@export var start_level: PackedScene
@export var options_menu: OptionsMenu
@export var button_container: Container

func _ready():
	start_button.button_up.connect(on_start_pressed)
	options_button.button_up.connect(on_options_pressed)
	exit_button.button_up.connect(on_exit_pressed)
	options_menu.goto_main_menu.connect(on_goto_main_menu)
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	button_container.visible=false
	options_menu.set_process(true)
	options_menu.visible=true
	
func on_exit_pressed() -> void:
	get_tree().quit()

func on_goto_main_menu() -> void:
	button_container.visible=true
	options_menu.visible=false
