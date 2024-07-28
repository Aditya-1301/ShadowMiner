extends Node2D

@onready var hearts_container = $CanvasLayer/HeartsContainer
@onready var player = $Player
@onready var label = $CanvasLayer/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.volume_db -= 24
	$Music.play()
	hearts_container.setMaxHearts(player.maxHealth)

func _process(_delta):
	hearts_container.updateHearts(player.currentHealth)
	label.text = "Money: " + str(player.money_aquired)


func _on_replay_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
