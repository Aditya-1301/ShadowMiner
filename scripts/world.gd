extends Node2D

@onready var hearts_container = $CanvasLayer/HeartsContainer
@onready var player = $Player
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var target_to_reach_label = $CanvasLayer/TargetToReachLabel
@onready var time_left_label = $CanvasLayer/TimeLeftLabel
var target = 500
var target_reached_count = 0
@onready var game_timer = $GameTimer

@onready var game_over = $GameOver as GameOver
@onready var game_over_label = $GameOver/ColorRect/GameOverLabel

var enemies = [
	preload("res://scenes/crow_enemy.tscn"),
	preload("res://scenes/shadow_enemy.tscn")
]
@onready var left_spawn_point = $LeftSpawnPoint
@onready var right_spawn_point = $RightSpawnPoint
@onready var spawn_timer = $SpawnTimer


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
	
	spawn_timer.timeout.connect(on_SpawnTimer_timeout)
	spawn_timer.start()
	
	game_over.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	game_over.on_Replay_button_pressed.connect(_on_replay_button_pressed)
	game_over.on_MainMenu_button_pressed.connect(_on_main_menu_button_pressed)


func _on_replay_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed():
	get_tree().paused = false
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
		if target_reached_count > 0:
			game_over_label.text = "Not Enough Gold to Continue!"
		elif target > player.show_balance():
			game_over_label.text = "Ran out of Time!"
		game_over.visible = true
		get_tree().paused = true
	elif player.currentHealth == 0:
		game_over_label.text = "You Died!"
		game_over.visible = true
		get_tree().paused = true

func on_SpawnTimer_timeout():
	# Instantiate a random intervall at least 9 sec or less than 20 sec
	spawn_timer.wait_time = randi_range(9,20)

	# Make random enemy toggle
	var random_index = randi() % enemies.size()
	print(random_index) 
	var rand_enemy = enemies[random_index].instantiate() as CharacterBody2D
	
	# Get random Spawn location based on wheter the player is closer to the spawner 
	# and assign the enemy to that location
	var left_spawn_point_player_delta = abs(player.position.x - left_spawn_point.position.x)
	var right_spawn_point_player_delta = abs(player.position.x - right_spawn_point.position.x)
	
	print("Left Spawn point delta: ", left_spawn_point_player_delta, "Right spawn point delta", right_spawn_point_player_delta)
	if(left_spawn_point_player_delta < right_spawn_point_player_delta):
		rand_enemy.position = left_spawn_point.position
	else:
		rand_enemy.position = right_spawn_point.position
	add_child(rand_enemy)

func _process(_delta):
	hearts_container.updateHearts(player.currentHealth)
	update_labels()
	show_end_screen()
