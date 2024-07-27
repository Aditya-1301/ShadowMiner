extends Node2D

@onready var hearts_container = $CanvasLayer/HeartsContainer
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.volume_db -= 24
	$Music.play()
	hearts_container.setMaxHearts(player.maxHealth)
	hearts_container.updateHearts(player.currentHealth)

