extends Object

class_name Util
	
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

static func await_any(functions : Array[Callable]):
	await AwaitAny.new(functions).any_finished

static func build_query(queryables : Array) -> Dictionary:
	var query : Dictionary = {}
	
	for q : Object in queryables:
		if q.has_method("build_query"):
			query.merge(q.build_query())
	
	return query

static func get_all_children(node) -> Array:
	var nodes : Array = []
	
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	
	return nodes

static func array_difference(arr1, arr2) -> Array:
	var only_in_arr1 = []
	for v in arr1:
		if not (v in arr2):
			only_in_arr1.append(v)
	return only_in_arr1

static func set_up_focus_connections(controls : Array):
	var i = 0
	
	for control in controls:
		control.focus_neighbor_left = NodePath()
		control.focus_neighbor_top = NodePath()
		control.focus_neighbor_bottom = NodePath()
		control.focus_neighbor_right = NodePath()
		
		var others = Util.array_difference(controls, [control])
		others.sort_custom(func (a, b): return control.global_position.distance_to(a.global_position) < control.global_position.distance_to(b.global_position)) 
		
		for other in others:
			var direction_vector = (other.global_position - control.global_position).normalized()
			if(abs(direction_vector.x) > abs(direction_vector.y)):
				if(sign(direction_vector.x) >= 0):
					if(control.focus_neighbor_right == NodePath()):
						control.focus_neighbor_right = other.get_path()
				elif(sign(direction_vector.x) <= 0):
					if(control.focus_neighbor_left == NodePath()):
						control.focus_neighbor_left = other.get_path()
			else:
				if(sign(direction_vector.y) <= 0):
					if(control.focus_neighbor_top == NodePath()):
						control.focus_neighbor_top = other.get_path()
				elif(sign(direction_vector.y) >= 0):
					if(control.focus_neighbor_bottom == NodePath()):
						control.focus_neighbor_bottom = other.get_path()
		
		if i < controls.size() - 1 : control.focus_next = controls[i + 1].get_path() 
		if i > 0: control.focus_previous = controls[i - 1].get_path()
		
		i += 1

static func deep_copy_resource_array(resource_array : Array):
	var deep_copy = []
	for resource in resource_array:
		deep_copy.append(resource.duplicate())
	
	return deep_copy

static func get_resource_name(resource: Resource):
	var path = resource.get_path()
	return path.right(-path.rfind("/") - 1).left(-5)
