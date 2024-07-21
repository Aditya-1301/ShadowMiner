extends CharacterBody2D

var speed = 50
var light_hit = false
var asleep = true
var found_body = null
@onready var last_player_pos = position

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if asleep:
		await(get_tree().create_timer(2).timeout)
		asleep = false
	if light_hit && (not asleep):
		last_player_pos = found_body.position
		velocity = (last_player_pos - position).normalized() * speed * delta
		move_and_collide(velocity)
		$AnimatedSprite2D.play("flying")
	elif velocity.abs() > Vector2.ZERO:
		velocity = Vector2.ZERO
		position = position.lerp(last_player_pos, delta)
		asleep = true
		$AnimatedSprite2D.play("idle")
		
		

func _on_detection_area_body_entered(body):
	found_body = body
	light_hit = true
	

func _on_detection_area_body_exited(_body):
	found_body = null
	light_hit = false
	
