extends MarginContainer

@export var next_scene_path: String


func _on_StartButton_pressed():
	get_tree().change_scene_to_file(next_scene_path)

func _on_QuitButton_pressed():
	get_tree().quit(0)

