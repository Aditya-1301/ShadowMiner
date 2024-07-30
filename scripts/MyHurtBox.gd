class_name HurtBox
extends Area2D


func _init():
	set_collision_layer_value(8, false)
	set_collision_mask_value(8, true)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", on_area_entered)
	
func on_area_entered(area: Area2D):
	if owner.name == "Player":
		if owner.has_method("take_damage"):
			print(owner.name, " took damage")
			owner.take_damage(area.owner._get("damagePoints"))
		return
	else:
		if area.name.begins_with("Bullet"):
			if owner.has_method("take_damage"):
				print(owner.name, " took damage")
				owner.take_damage(area.owner._get("damagePoints"))
