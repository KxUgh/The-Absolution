class_name OptionsMenu
extends Control

@export var main_menu_button: Button
@export var reset_button: Button

signal goto_main_menu

func _ready():
	main_menu_button.pressed.connect(on_main_menu_button_pressed)
	reset_button.pressed.connect(reset)
	set_process(false)

func on_main_menu_button_pressed() -> void:
	goto_main_menu.emit()
	set_process(false)

func reset() -> void:
	Common.save_player_data(PlayerData.new())
