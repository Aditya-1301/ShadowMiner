extends RigidBody2D


var value = randi_range(50, 100)
var player_in_area = false
@onready var pickable_area = $pickable_area
@onready var reappear_time = $reappear_time
@onready var coin = $"."


signal coin_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0
	pickable_area.body_entered.connect(on_body_entered)
	pickable_area.body_exited.connect(on_body_exited)
	reappear_time.connect("timeout", on_reappear_timeout)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in_area:
		hide_and_collect_coin()


func hide_and_collect_coin():
	hide()
	# Turn off collsion with player (make player unable to scan this obejct)
	set_collision_mask_value(4, false)
	
	# Use coin_collected signal to get the value of the coin!
	coin_collected.emit(value)
	
	# Teleport to random location (in vicinity)
	# TBD
	coin.position = Vector2(randi_range(50, get_viewport_rect().size.x - 50), -(randi_range(-50, get_viewport_rect().size.y - 50)))
	
	# Start time until to reappera
	reappear_time.start()

func on_body_entered(body: Node2D) -> void:
	if body.name == str("Player"):
		player_in_area = true
		
func on_body_exited(body: Node2D) -> void:
	if body.name == str("Player"):
		player_in_area = false

func on_reappear_timeout() -> void:
	# Change value to random value
	value = randi_range(50, 100)
	show()
