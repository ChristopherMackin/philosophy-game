extends Object

class_name Util

static func lerp_to_position(node : Node2D, target : Vector2, duration : float):
	if node.has_node("Lerp2DNode"):
		node.get_node("Lerp2DNode").queue_free()
	
	var lerp = Node2D.new()
	lerp.name = "Lerp2DNode"
	lerp.set_script(Lerp2D)
	node.add_child(lerp)
	
	lerp.starting_pos = node.position
	lerp.target_pos = target
	lerp.duration = duration
	
	await lerp.finished
	
static func sort_children(node : Node2D, sort_func : Callable):
	var children := node.get_children()
	var sorted_nodes := children

	sorted_nodes.sort_custom(
		# For descending order use > 0
		sort_func
	)

	for child in children:
		node.remove_child(child)

	for child in sorted_nodes:
		node.add_child(child)

static func set_parent(node : Node, parent: Node):
	if node.get_parent() != null:
		node.reparent(parent)
	else:
		parent.add_child(node)

static func await_all(functions : Array[Callable]):
	await AwaitAll.new(functions).all_finished
