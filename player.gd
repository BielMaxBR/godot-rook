extends KinematicBody2D

export(NodePath) var corasaun_path
onready var corasaun = get_node(corasaun_path)

func _ready():
	pass

func _physics_process(delta):
	move_and_slide(Vector2(Input.get_axis("L","R"), Input.get_axis("U","D")) * 200)
