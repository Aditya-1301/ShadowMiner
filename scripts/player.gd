extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var maxHealth = 3
var currentHealth = maxHealth

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var default_gravity_modifier = 1
var current_gravity_modifier = default_gravity_modifier
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var attraction_zone = $"Attraction Zone"
@onready var items = $"../Items"
@onready var az_sprite_2d = $AttractionZoneSprite
@onready var game_over = %GameOver


@onready var gravity_debuff_timer = $"../gravity_debuff_timer"
var money_aquired = 0

signal on_money_change

func _ready():
	attraction_zone.gravity_space_override = attraction_zone.SPACE_OVERRIDE_DISABLED
	az_sprite_2d.visible = false
	items.on_gravity_change.connect(set_gravity_multiplier)
	gravity_debuff_timer.timeout.connect(reset_gravity_modifer)
	items.on_increase_money.connect(set_money_increase)
	on_money_change.connect(show_balance)

func _input(_event):
	if Input.is_action_pressed("staff_on"):
		attraction_zone.gravity_space_override = attraction_zone.SPACE_OVERRIDE_COMBINE
		attraction_zone.gravity_point = true
		print("Staff Enabled!")
		for i in items.get_children():
			i.gravity_scale = current_gravity_modifier
	elif Input.is_action_just_released("staff_on"):
		attraction_zone.gravity_space_override = attraction_zone.SPACE_OVERRIDE_DISABLED
		attraction_zone.gravity_point = false
		print("Staff Disabled!")
	elif Input.is_action_just_pressed("aim_set"):
		attraction_zone.rotation = get_local_mouse_position().angle() + PI / 2
		az_sprite_2d.rotation = get_local_mouse_position().angle() -PI/2
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
		velocity.x = direction * SPEED
		if animated_sprite_2d.animation != "run":
			animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and animated_sprite_2d.animation != "idle":
			animated_sprite_2d.play("idle")
	
	# Handle staff activation animation
	if Input.is_action_pressed("staff_on") and attraction_zone.gravity_point and animated_sprite_2d.animation != "activate_staff":
		animated_sprite_2d.play("activate_staff")
		az_sprite_2d.visible = true
	
	if Input.is_action_just_released("staff_on"):
		az_sprite_2d.visible = false
	
	# Handle attack animation
	if Input.is_action_pressed("attack") and not attraction_zone.gravity_point and animated_sprite_2d.animation != "attack":
		animated_sprite_2d.play("attack")

	move_and_slide()


func _on_hurt_box_area_entered(area):
	if area.name == "HurtBox":
		currentHealth -= 1
		if currentHealth < 0:
			# change scene to YOU DIED SCREEN
			currentHealth = maxHealth
			money_aquired = 0
			game_over.visible = true
			

func set_money_increase(money):
	money_aquired += money
	on_money_change.emit()
	
func show_balance():
	print("Current amount of Money: ", money_aquired)

func set_gravity_multiplier(gravity_debuff_multiplier):
	current_gravity_modifier *= gravity_debuff_multiplier
	gravity_debuff_timer.one_shot = true
	gravity_debuff_timer.start()
	
func reset_gravity_modifer():
	current_gravity_modifier = default_gravity_modifier
