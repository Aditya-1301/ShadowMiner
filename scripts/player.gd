extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var maxHealth = 3
var currentHealth = maxHealth
var damagePoints = 1
var money_aquired = 0
var philstone_aquired = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var default_gravity_modifier = 1
var current_gravity_modifier = default_gravity_modifier

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var attraction_zone = $"Attraction Zone"
@onready var items = $"../Items"
@onready var game_over = %GameOver
@onready var az_sprite_2d = $"Attraction Zone/AttractionZoneSprite"
@onready var game_over_label = $"../GameOver/ColorRect/GameOverLabel"
@onready var gravity_debuff_timer = $"../gravity_debuff_timer"

signal on_money_aquired_change
signal on_philstone_aquired_change

func _ready():
	attraction_zone.gravity_space_override = attraction_zone.SPACE_OVERRIDE_DISABLED
	az_sprite_2d.visible = false
	items.on_gravity_change.connect(set_gravity_multiplier)
	gravity_debuff_timer.timeout.connect(reset_gravity_modifer)
	items.on_increase_money.connect(set_money_increase)
	on_money_aquired_change.connect(show_balance)
	items.on_philShard_increase.connect(increase_philstone_amount)
	on_philstone_aquired_change.connect(show_philstone)

func _input(_event):
	if Input.is_action_pressed("staff_on"):
		attraction_zone.gravity_space_override = attraction_zone.SPACE_OVERRIDE_COMBINE
		attraction_zone.gravity_point = true
		print("Staff Enabled!")
		for i in items.get_children():
			i.gravity_scale = current_gravity_modifier
		if animated_sprite_2d.flip_h and az_sprite_2d.flip_h == false:
			az_sprite_2d.flip_h = true
			#az_sprite_2d.position.x += 42 # Decrementing by 32 places the sprite in a relatively better position to the flipped player sprite
	elif Input.is_action_just_released("staff_on"):
		attraction_zone.gravity_space_override = attraction_zone.SPACE_OVERRIDE_DISABLED
		attraction_zone.gravity_point = false
		if animated_sprite_2d.flip_h == true and az_sprite_2d.flip_h == true:
			az_sprite_2d.flip_h = false
			#az_sprite_2d.position.x -= 42 # Incrementing by 32 moves it to its original position
		print("Staff Disabled!")
	elif Input.is_action_just_pressed("aim_set"):
		attraction_zone.rotation = get_local_mouse_position().angle() + PI / 2
		#az_sprite_2d.rotation = get_local_mouse_position().angle() -PI/2 ; For Rotation = 172.6 degrees
	elif Input.is_action_just_pressed("aim_cancel"):
		attraction_zone.rotation = 0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if animated_sprite_2d.animation != "fall":
			animated_sprite_2d.play("fall")
	else:
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("jump")
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		if not Input.is_action_just_pressed("staff_on") and not Input.is_action_pressed("attack"):
			velocity.x = direction * SPEED
			if animated_sprite_2d.animation != "run":
				animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = direction < 0
			if animated_sprite_2d.flip_h == true and Input.is_action_pressed("staff_on"):
				print("reached1")
			elif az_sprite_2d.flip_h == false and Input.is_action_pressed("staff_on"):
				print("reached2")
	else:
		if not Input.is_action_just_pressed("staff_on") and not Input.is_action_pressed("attack"):
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor() and animated_sprite_2d.animation != "idle":
				animated_sprite_2d.play("idle")
	
	# Handle staff activation animation
	if Input.is_action_pressed("staff_on") and attraction_zone.gravity_point and animated_sprite_2d.animation != "activate_staff":
		velocity = Vector2(0.0,velocity.y)
		animated_sprite_2d.play("activate_staff")
		az_sprite_2d.visible = true
	
	if Input.is_action_just_released("staff_on"):
		velocity = Vector2(0.0,velocity.y)
		az_sprite_2d.visible = false
	
	# Handle attack animation
	if Input.is_action_pressed("attack") and not attraction_zone.gravity_point and animated_sprite_2d.animation != "attack":
		velocity = Vector2(0.0,velocity.y)
		animated_sprite_2d.play("attack")

	move_and_slide()


func _get(property):
	if property == "damagePoints":
		return damagePoints


func take_damage(_value):
	currentHealth -= 1
	animated_sprite_2d.play("hit")


func set_money_increase(money):
	money_aquired += money
	on_money_aquired_change.emit()
	
	
func show_balance():
	#print("Current amount of Money: ", money_aquired)
	return money_aquired


func increase_philstone_amount():
	philstone_aquired += 1
	on_philstone_aquired_change.emit()


func show_philstone():
	#print("Current amount of philstone: ", philstone_aquired)
	return philstone_aquired

func set_gravity_multiplier(gravity_debuff_multiplier):
	current_gravity_modifier *= gravity_debuff_multiplier
	gravity_debuff_timer.one_shot = true
	gravity_debuff_timer.start()


func reset_gravity_modifer():
	current_gravity_modifier = default_gravity_modifier
