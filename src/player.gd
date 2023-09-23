extends RigidBody2D

@export var corasaun_path: NodePath
@onready var corasaun = get_node(corasaun_path)


func _physics_process(_delta):
	linear_velocity = (Vector2(Input.get_axis("L","R"), Input.get_axis("U","D")) * 250)
 

func _integrate_forces(_state: PhysicsDirectBodyState2D):
	rotation_degrees = 0
