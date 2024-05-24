@tool
extends GraphEdit

class_name EventGraph

@export var start_node_prefab : PackedScene
var start_node : GraphNode

func _on_delete_nodes_request(nodes):
	for n in nodes:
		get_node(NodePath(n)).queue_free()

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
	var tree = EventTree.new()
	
	for node : EventNode in get_children():
		#Get all connections for this event node
		var connections = get_connection_list().filter(func (x):
			return x.from_node == node.name
		)
		
		#Sort by port order
		connections.sort_custom(func (a, b): 
			return a.from_port > b.from_port
		)
		
		#Make an array of the events
		var events : Array[Event] 
		events.assign(connections.map(func(x):
			return get_node(NodePath(x.to_node)).event
		))
		
		#Update node information
		node.update(events)
		
		#Set start node
		if node.event is StartEvent:
			tree.start_event = node.event
	
	return tree

func load_event_tree(event_tree: EventTree):
	clear_graph()

func clear_graph():
	for c in get_children():
		c.queue_free()
	var start_node = start_node_prefab.instantiate()
	add_child(start_node)
