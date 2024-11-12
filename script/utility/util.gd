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

static func build_query(queryables : Array) -> Dictionary:
	var query : Dictionary
	
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

static func array_difference(arr1, arr2):
	var only_in_arr1 = []
	for v in arr1:
		if not (v in arr2):
			only_in_arr1.append(v)
	return only_in_arr1
