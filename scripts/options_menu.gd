class_name OptionsMenu
extends Control

@export var main_menu_button: Button

signal goto_main_menu

func _ready():
	main_menu_button.button_up.connect(on_main_menu_button_pressed)
	set_process(false)

func on_main_menu_button_pressed() -> void:
	goto_main_menu.emit()
	set_process(false)
