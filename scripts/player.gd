extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var attraction_zone = $"Attraction Zone"


func _ready():
	attraction_zone.gravity_space_override = attraction_zone.SPACE_OVERRIDE_DISABLED

func _input(_event):
	if Input.is_action_just_pressed("staff_on"):
		attraction_zone.gravity_space_override = attraction_zone.SPACE_OVERRIDE_COMBINE
		attraction_zone.gravity_point = true
		print("Staff Enabled!")
	elif Input.is_action_just_pressed("staff_off"):
		attraction_zone.gravity_space_override = attraction_zone.SPACE_OVERRIDE_DISABLED
		attraction_zone.gravity_point = false
		print("Staff Disabled!")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play("fall")
	else:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("jump")
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.play("run")
		# Flip the sprite based on direction
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("idle")
	
	if Input.is_action_just_pressed("staff_on"):
		animated_sprite_2d.play("attack1")

	move_and_slide()
