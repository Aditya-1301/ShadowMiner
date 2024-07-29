extends CanvasLayer

@onready var game_over = $"."

func _ready():
	game_over.visible = false
	$GameOverMusic.volume_db = -24
	$GameOverMusic.play()

