extends Node2D

var tamanho = 15
func _ready():
	gerar_elos()

func _physics_process(delta):
#	$player/Line2D.points = PoolVector2Array()
#	$player/Line2D.points.fill(Vector2.ZERO)
#	$player/Line2D.points.resize(tamanho)
	for i in $elos.get_child_count():
		var elo = $elos.get_child(i)
		var pin = elo.get_node("Pin")
		
		var next
		if pin.node_b:
			next = get_node(pin.node_b)
			if not next:
				continue
			if $player/Line2D.points.size() == i:
				$player/Line2D.add_point($player.to_local(next.position))
			else:
				$player/Line2D.points[i] = $player.to_local(next.position)

func gerar_elos():
	for i in tamanho:
		var elo = $elos/elo.duplicate()
		$elos.add_child(elo)
		elo.mode = RigidBody2D.MODE_RIGID
		var new_position = $elos/elo.position
		new_position.y += (i+1) * -(192 / tamanho)
		elo.position = new_position
		
#		if $elos.get_child(i-1):
		elo.get_node("Pin").node_a = elo.get_path()
		$elos.get_child(i).get_node("Pin").node_b = elo.get_path()
		if i == tamanho-1:
			$corasaun.global_position = elo.global_position
			elo.get_node("Pin").node_b = $corasaun.get_path()
