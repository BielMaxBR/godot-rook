tool
class_name Rope
extends Line2D

const JOINT_SCN: PackedScene = preload("res://src/joint.tscn")
export var n_joints: int = 10
export var size = 128

export var source_path: NodePath setget set_source_path
var source: Node2D

export var target_path: NodePath setget set_target_path
var target: Node2D
var target_pin := PinJoint2D.new()

var joints: Array


func set_target_path(value: NodePath) -> void:
	target_path = value
	update_configuration_warning()


func set_source_path(value: NodePath) -> void:
	source_path = value
	update_configuration_warning()


func _get_configuration_warning() -> String:
	var warning := ""
	var nl: bool
	
	if source_path.is_empty():
		warning += "- Please add a source"
		nl = true
	
	if target_path.is_empty():
		warning += ("\n" if nl else "") + "- Please add a target"
	
	if target_path.is_empty():
		warning += ("\n" if nl else "") + "- Please add a line"
	
	return warning


func _ready() -> void:
	
	if Engine.is_editor_hint():
		set_physics_process(false)
		return
	
	target = get_node_or_null(target_path)
	source = get_node_or_null(source_path)
	
	if target == null or source_path == null:
		set_physics_process(false)
		return
	
	# Setup first joint
	joints = [JOINT_SCN.instance()]
	add_child(joints[0])
	joints[0].global_position = target.global_position
	
	# Setup target pin
	
	yield(get_tree(), "idle_frame")
	target.add_child(target_pin)
	target_pin.node_a = target.get_path()
	target_pin.node_b = joints[0].get_path()
	
	generate_joints()
	
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
			
			if get_point_count() == i:
				add_point(target.to_global(next.position))
			else:
				set_point_position(i, target.to_global(next.position))


func generate_joints() -> void:
	
	for i in n_joints:
		var new = joints[0].duplicate()
		add_child(new)
		new.mode = RigidBody2D.MODE_RIGID
		
		new.position = joints[0].position
		new.position.y += (i + 1) * -(size / n_joints)
		
		new.get_node("Pin").node_a = new.get_path()
		get_child(i).get_node("Pin").node_b = new.get_path()
		
		if i == n_joints - 1:
			source.global_position = new.global_position
			new.get_node("Pin").node_b = source.get_path()
