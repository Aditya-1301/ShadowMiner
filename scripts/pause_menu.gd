extends Control

@export var game_manager: Node
@onready var pause_menu: Control = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	print("connect buffer")
	if game_manager:
		game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)


func _on_game_manager_toggle_game_paused(is_paused: bool):
	if is_paused:
		show()
	else: 
		hide()


func _on_resume_button_pressed() -> void:
	game_manager.is_game_paused = false


func _on_restart_button_pressed() -> void:
	game_manager.is_game_paused = false
	get_tree().change_scene_to_file("res://scenes/game_manager.tscn")


func _on_quit_button_pressed() -> void:
	#game_manager.is_game_paused = false
	#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	get_tree().quit()
