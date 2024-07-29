class_name GameOver
extends CanvasLayer

@onready var game_over = $"."
@onready var replay_button = $ColorRect/MenuItems/ReplayButton
@onready var main_menu_button = $ColorRect/MenuItems/MainMenuButton

signal on_Replay_button_pressed
signal on_MainMenu_button_pressed


func _ready():
	game_over.visible = false
	$GameOverMusic.volume_db = -24
	$GameOverMusic.play()
	replay_button.pressed.connect(Replay_pressed)
	main_menu_button.pressed.connect(MainMenu_pressed)
	
func Replay_pressed():
	on_Replay_button_pressed.emit()

func MainMenu_pressed():
	on_MainMenu_button_pressed.emit()
