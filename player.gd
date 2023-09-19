extends RigidBody2D

export(NodePath) var corasaun_path
onready var pin: PinJoint2D = $PinJoint2D
onready var line: Line2D = $Line2D
onready var corasaun = get_node(corasaun_path)

func _ready():
	pass

func _physics_process(_delta):
	linear_velocity = (Vector2(Input.get_axis("L","R"), Input.get_axis("U","D")) * 250)
 
