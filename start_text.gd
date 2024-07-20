extends Button

@export var next_scene_path: String

func _on_pressed():
	get_tree().change_scene_to_file(next_scene_path)
	
