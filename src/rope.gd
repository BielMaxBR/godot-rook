extends Node2D

export var n_joints: int = 10
export var size = 128

export var player_path: NodePath
var player: Node2D

export var source_path: NodePath
var source: Node2D

var joints: Array
onready var joint: RigidBody2D = $joint


func _ready() -> void:
	player = get_node_or_null(player_path)
	assert(player != null)
	
	source = get_node_or_null(source_path)
	assert(source != null)
	
	joint.global_position = player.global_position
	assert(player.pin != null)
	
	(player.pin as PinJoint2D).node_b = joint.get_path()
	assert(player.line != null)
	
	generate_joints()
	
	joints = []
	for child in get_children():
		if child is RigidBody2D:
			joints.append(child)


func _physics_process(_delta: float) -> void:
	
	for i in joints.size():
		var curr: RigidBody2D = joints[i]
		var pin = curr.get_node("Pin")
		var next
		
		if pin.node_b:
			next = get_node(pin.node_b)
			
			if not next:
				continue
			
			if player.line.get_point_count() == i:
				player.line.add_point(player.to_local(next.position))
			else:
				player.line.set_point_position(i, player.to_local(next.position))


func generate_joints() -> void:
	
	for i in n_joints:
		var new = joint.duplicate()
		add_child(new)
		new.mode = RigidBody2D.MODE_RIGID
		
		new.position = joint.position
		new.position.y += (i + 1) * -(size / n_joints)
		
		new.get_node("Pin").node_a = new.get_path()
		get_child(i).get_node("Pin").node_b = new.get_path()
		
		if i == n_joints - 1:
			source.global_position = new.global_position
			new.get_node("Pin").node_b = source.get_path()
