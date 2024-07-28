extends RigidBody2D


var value = randi_range(50, 100)
var player_in_area = false
@onready var pickable_area = $pickable_area
@onready var reappear_time = $reappear_time
@onready var gold = $"."


signal on_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0
	pickable_area.body_entered.connect(on_body_entered)
	pickable_area.body_exited.connect(on_body_exited)
	reappear_time.one_shot = true
	reappear_time.connect("timeout", on_reappear_timeout)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in_area:
		hide_and_collect()
		# Teleport to random location (in vicinity)
		gold.position = Vector2(randf_range(50.0, get_viewport_rect().size.x - 50.0), -(randf_range(-50.0, get_viewport_rect().size.y - 100.0)))
		player_in_area = false
	
		# Start time until reappearace
		reappear_time.start()


func hide_and_collect():
	hide()
	# Turn off collsion with player (make player unable to scan this obejct)
	set_collision_mask_value(4, false)
	pickable_area.set_collision_mask_value(1, false)
	
	# Use collected signal to get the value this item!
	on_collected.emit(value)

func on_body_entered(body: Node2D) -> void:
	if body.name == str("Player"):
		player_in_area = true
		
func on_body_exited(body: Node2D) -> void:
	if body.name == str("Player"):
		player_in_area = false

func on_reappear_timeout() -> void:
	set_collision_mask_value(4, true)
	pickable_area.set_collision_mask_value(1, true)
	
	show()
