extends Panel


@onready var heart_frame = $HeartFrame
@onready var heart = $Heart

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update(whole: bool):
	if whole:
		heart_frame.visible = true
		heart.visible = true
	else: 
		heart_frame.visible = true
		heart.visible = false
	
