extends Node2D

@onready var hearts_container = $CanvasLayer/HeartsContainer
@onready var player = $Player
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var target_to_reach_label = $CanvasLayer/TargetToReachLabel
@onready var time_left_label = $CanvasLayer/TimeLeftLabel
var target = 500
var target_reached_count = 0
@onready var game_timer = $GameTimer

@onready var game_over = $GameOver
@onready var game_over_label = $GameOver/ColorRect/GameOverLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.volume_db -= 24
	$Music.play()
	hearts_container.setMaxHearts(player.maxHealth)
	hearts_container.updateHearts(player.currentHealth)
	score_label.text = "Score: " + str(player.money_aquired)
	target_to_reach_label.text = "Target: " + str(target)
	time_left_label.text = "Time Left: " + str(floor(game_timer.time_left))
	game_timer.start()


func _on_replay_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func update_labels():
	score_label.text = "Score: " + str(player.money_aquired)
	if player.money_aquired >= target and game_timer.time_left > 0:
		target_reached_count += 1
		target += 500 * target_reached_count
		game_timer.wait_time += 15 * target_reached_count
		game_timer.start()
	target_to_reach_label.text = "Target: " + str(target)
	if game_timer.time_left > 0:
		time_left_label.text = "Time: " + str(floor(game_timer.time_left))

func show_end_screen():
	if game_timer.time_left == 0:
		game_over.visible = true
		if target_reached_count > 0:
			game_over_label.text = "Not Enough Gold to Continue!"
		elif target > player.show_balance():
			game_over_label.text = "Ran out of Time!"
		get_tree().paused = true

func _process(_delta):
	hearts_container.updateHearts(player.currentHealth)
	update_labels()
	show_end_screen()
