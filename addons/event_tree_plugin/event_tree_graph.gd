@tool
extends GraphEdit

func _on_delete_nodes_request(nodes):
	for n in nodes:
		get_node(NodePath(n)).queue_free()

#Add in connection type for single vs double
func _on_connection_request(from_node, from_port, to_node, to_port):
	var connections = get_connection_list().filter(func (x):
		return x.from_node == from_node && x.from_port == from_port
	)
	for c in connections:
		disconnect_node(c.from_node, c.from_port, c.to_node, c.to_port)
	
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node, from_port, to_node, to_port)

func get_event_tree() -> EventTree:
	return EventTree.new()

func load_event_tree(event_tree: EventTree):
	clear_graph()

func clear_graph():
	for c in get_children():
		c.queue_free()
