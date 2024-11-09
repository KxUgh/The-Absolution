class_name MainMenu
extends Control

@onready var start_button=$MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var options_button=$MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var exit_button=$MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level=preload("res://scenes/main.tscn") as PackedScene
@onready var options_menu=$Options_Menu as OptionsMenu
@onready var margin_containter=$MarginContainer as MarginContainer

func _ready():
	start_button.button_up.connect(on_start_pressed)
	options_button.button_up.connect(on_options_pressed)
	exit_button.button_up.connect(on_exit_pressed)
	options_menu.goto_main_menu.connect(on_goto_main_menu)
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	margin_containter.visible=false
	options_menu.set_process(true)
	options_menu.visible=true
	
func on_exit_pressed() -> void:
	get_tree().quit()

func on_goto_main_menu() -> void:
	margin_containter.visible=true
	options_menu.visible=false
