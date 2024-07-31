extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D
var speed : int = 300
var direction : int

signal kill

func _physics_process(delta):
	animated_sprite_2d.flip_h = direction < 0
	move_local_x(direction * delta * speed)
	animated_sprite_2d.play("fire")
	animated_sprite_2d.self_modulate = "976eff"
	self.scale = Vector2(3, 3)

func _on_timer_timeout():
	print("removed bullet")
	queue_free()
	

func _on_hitbox_body_entered(body):
	print("bullet just hit ", body.name)
	print("hitbox body entered")
	if body.name.begins_with("ShadowEnemy") or body.name.begins_with("CrowEnemy"):
		if body.healthPoints > 0:
			body.healthPoints -= 1
		else:
			kill.emit()
			body.queue_free()
	
