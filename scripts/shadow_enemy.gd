extends CharacterBody2D

const LEFT = -1
const RIGHT = 1

var speed = 0.5
var healthPoints = 5
var damagePoints = 1
var direction = null
var damaged_state = false
@onready var player = $"../Player" as CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var enemy_hurt_box = $EnemyHurtBox

signal on_death
signal on_damage_taken

func _ready():
	velocity = Vector2(0.0, 0.0)
	$AnimatedSprite2D.play("Walking")
	on_damage_taken.connect(do_damage_taken)
	on_death.connect(do_death)
	
	
	#Turn on HurtBoxLayer for this layer such that this does damage to the Player
	enemy_hurt_box.set_collision_layer_value(8, true)
	
	
func _physics_process(_delta):
	update_velocity()
	move_and_collide(velocity)

func _get(property):
	if property == "damagePoints":
		return damagePoints

func take_damage(value):
	if (healthPoints - value) <= 0:
		collision_layer = 0
		collision_mask = 0
		healthPoints = 0
		on_death.emit()
	else:
		healthPoints -= value
		on_damage_taken.emit()
	
func do_damage_taken():
	damaged_state = true

func do_death():
	queue_free()

func update_velocity():
	var x_position_delta = player.position.x - position.x
	if not damaged_state:
		$AnimatedSprite2D.play("Walking")
	else:
		$AnimatedSprite2D.play("Idle")
		position.x = lerp(position.x-(100*direction), position.x, .5)
		damaged_state = false
	if(x_position_delta < 0):
		$AnimatedSprite2D.flip_h = true
		direction = LEFT
	else:
		$AnimatedSprite2D.flip_h = false
		direction = RIGHT
		
	velocity = Vector2(direction*speed, 0.0)
