extends Object

class_name Help

static func lerp_to_position(node : Node2D, target : Vector2, duration : float):
	if node.has_node("Lerp2D"):
		node.get_node("Lerp2D").queue_free()
	
	var lerp = Node2D.new()
	lerp.name = "Lerp2D"
	lerp.set_script(Lerp2D)
	node.add_child(lerp)
	
	lerp.starting_pos = node.position
	lerp.target_pos = target
	lerp.duration = duration
