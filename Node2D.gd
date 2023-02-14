extends Node2D

export var elos = 10
export var tamanho = 128
func _ready():
	$elos/elo.global_position = $player.global_position
	$player/PinJoint2D.node_b = $elos/elo.get_path()
	gerar_elos()

func _physics_process(delta):
	for i in $elos.get_child_count():
		var elo = $elos.get_child(i)
		var pin = elo.get_node("Pin")
		
		var next
		if pin.node_b:
			next = get_node(pin.node_b)
			if not next:
				continue
			if $player/Line2D.get_point_count() == i:
				$player/Line2D.add_point($player.to_local(next.position))
			else:
				$player/Line2D.set_point_position(i, $player.to_local(next.position))

func gerar_elos():
	for i in elos:
		var elo = $elos/elo.duplicate()
		$elos.add_child(elo)
		elo.mode = RigidBody2D.MODE_RIGID
		var new_position = $elos/elo.position
		new_position.y += (i+1) * -(tamanho / elos)
		elo.position = new_position
		
#		if $elos.get_child(i-1):
		elo.get_node("Pin").node_a = elo.get_path()
		$elos.get_child(i).get_node("Pin").node_b = elo.get_path()
		if i == elos-1:
			$corasaun.global_position = elo.global_position
			elo.get_node("Pin").node_b = $corasaun.get_path()
