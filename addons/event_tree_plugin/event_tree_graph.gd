@tool
extends GraphEdit

class_name EventGraph

@export var start_node_prefab : PackedScene
@onready var event_node_type_parent = $"../EventNodeTypeParent"
@onready var start_node = $StartNode

func _on_delete_nodes_request(nodes):
	for name in nodes:
		var n = get_node(NodePath(name))
		if n != start_node:
			n.queue_free()

func _on_connection_request(from_node, from_port, to_node, to_port):
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node, from_port, to_node, to_port)

func _on_connection_drag_started(from_node, from_port, is_output):
	var connections = get_connection_list().filter(func (x):
		return x.from_node == from_node && x.from_port == from_port
	)
	for c in connections:
		disconnect_node(c.from_node, c.from_port, c.to_node, c.to_port)

func get_event_tree() -> EventTree:
	
	#Refresh events
	for node : EventNode in get_event_nodes():
		node.make_new_event()
	
	#Make new tree and add starting event
	var tree = EventTree.new()
	
	var start_connections = get_connection_list().filter(func (x):
		return x.from_node == start_node.name
	)
	
	if start_connections.size() <= 0:
		return tree
	
	tree.start_event = get_node(NodePath(start_connections[0].to_node)).event
	
	#Set inputs and outputs for all events
	for node : EventNode in get_event_nodes():
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
		
		node.set_connections(events)
	
	return tree

func load_event_tree(event_tree: EventTree):
	clear_graph()
	
	var first_event = event_tree.start_event
	
	if !first_event:
		return
	
	var first_node = add_event_recursive(first_event)
	connect_node(start_node.name, 0, first_node.name, 0)
	

func add_event_recursive(event : Event) -> EventNode:
	for child in get_event_nodes():
		if child.event == event:
			return null
	
	var prefab
	
	for p : EventNode in event_node_type_parent.get_children():
		if p.event_action.get_script() == event.action.get_script():
			prefab = p
			break
	
	var node = prefab.duplicate()
	node.set_event(event)
	add_child(node)
	
	var i : int = 0
	for e in event.outputs:
		var next_node = add_event_recursive(e)
		connect_node(node.name, i, next_node.name, i)
		i += 1
	
	return node

func clear_graph():
	for c in get_children():
		if c != start_node:
			c.queue_free()

func get_event_nodes():
	var event_nodes = get_children()
	var index = event_nodes.find(start_node)
	event_nodes.remove_at(index)
	return event_nodes
