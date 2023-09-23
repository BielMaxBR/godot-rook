extends Area2D

var default_gravity = Vector2(80,0)

func _ready():
	gravity_direction = default_gravity.rotated(rotation_degrees)
	pass
