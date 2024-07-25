extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.volume_db -= 24
	$Music.play()
