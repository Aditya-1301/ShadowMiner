extends Node2D

var multiplier_buff_default = 1
var current_multiplier_buff = 1
var multiply_state = false

@onready var player = $"../Player"
@onready var buff_time = $"../buff_timer" as Timer
@onready var money_buff = $MoneyBuff
@onready var special_item_timer = $"../SpecialItemTimer"
@onready var gravity_debuff = $GravityDebuff
@onready var philosophers_shard = $PhilosophersShard


signal on_gravity_change
signal on_increase_money
signal on_philShard_increase

# Called when the node enters the scene tree for the first time.
func _ready():
	special_item_timer.one_shot = true
	special_item_timer.timeout.connect(on_special_item_timer_timeout)
	buff_time.timeout.connect(on_buff_time_timeout)
	toggle_visability_special_items()
	special_item_timer.start()
	
	for item: RigidBody2D in get_children():
		# Simulate random spawning
		item.position = Vector2(randf_range(50.0, get_viewport_rect().size.x - 50.0), -(randf_range(-50.0, get_viewport_rect().size.y - 100.0)))
		
		# Do something when the player picks up the items
		if item.name.begins_with("Gold"):
			item.connect("on_collected", on_gold_collected)
			
		if item.name.begins_with("Rock"):
			item.connect("on_collected", on_rock_collected)
			
		if item.name.begins_with("MoneyBuff"):
			item.connect("on_collected", on_mbuff_collected)
			
		if item.name.begins_with("GravityDebuff"):
			item.connect("on_collected", on_GravityDebuff_collected)
			
		if item.name.begins_with("PhilosophersShard"):
			item.connect("on_collected", on_PhilShard_collected)
			

func _process(_delta):
	if current_multiplier_buff != multiplier_buff_default:
		multiply_state = true

#Item logic
func on_gold_collected(value):
	if multiply_state:
		on_increase_money.emit(current_multiplier_buff * value)
	else:
		on_increase_money.emit(value)

func on_rock_collected(value):
	if multiply_state:
		on_increase_money.emit(current_multiplier_buff * value)
	else:
		on_increase_money.emit(value)

func on_GravityDebuff_collected(gravity_modifier):
	on_gravity_change.emit(gravity_modifier)

func on_mbuff_collected(value):
	current_multiplier_buff = value
	buff_time.start()

func on_PhilShard_collected():
	on_philShard_increase.emit()
	
# Buff time logic
func on_buff_time_timeout():
	# Reset money buff
	current_multiplier_buff = multiplier_buff_default
	multiply_state = false

# Buff Spawn timer logic
func on_special_item_timer_timeout():
	toggle_visability_special_items()

func toggle_visability_special_items():
	gravity_debuff.visible = not gravity_debuff.visible 
	money_buff.visible = not money_buff.visible
	philosophers_shard.visible = not philosophers_shard.visible
