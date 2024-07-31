extends MarginContainer

#@export var next_scene_path: String
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer
var next_scene = preload("res://scenes/world.tscn") as PackedScene

func _ready():
	options_menu.exit_options_menu.connect(on_exit_options_button_pressed)
	
	$IntroSound.volume_db -= 7.5
	print("Currrent Volume: ", $IntroSound.volume_db)
	$IntroSound.play()
	

func _on_StartButton_pressed():
	#get_tree().change_scene_to_packed(next_scene)
	get_tree().change_scene_to_file("res://scenes//world.tscn")


func _on_QuitButton_pressed():
	get_tree().quit(0)

func _on_options_button_pressed():
	print("Load options")
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_options_button_pressed():
	margin_container.visible = true
	options_menu.visible = false
