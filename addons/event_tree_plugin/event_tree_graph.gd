@tool
extends GraphEdit

class_name EventGraph

@export var start_node_prefab : PackedScene
var start_node : GraphNode
@onready var event_node_type_parent = $"../EventNodeTypeParent"

func _on_delete_nodes_request(nodes):
	for name in nodes:
		var n = get_node(NodePath(name))
		if not n is StartEventNode:
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
	
	var se = event_tree.start_event
	if !se:
		return
	
	var first_event = se.next_list[0] if se.next_list.size() > 0 else null
	
	if first_event:
		var first_node = add_event_recursive(first_event)
		connect_node("StartNode", 0, first_node.name, 0)
	

func add_event_recursive(event : Event) -> EventNode:
	for child in get_children():
		if child.event == event:
			return null
	
	var prefab
	
	for p in event_node_type_parent.get_children():
		if p.event.get_script() == event.get_script():
			prefab = p
			break
	
	var node = prefab.duplicate()
	node.set_event(event)
	add_child(node)
	
	var i : int = 0
	for e in event.next_list:
		var next_node = add_event_recursive(e)
		connect_node(node.name, i, next_node.name, i)
		i += 1
	
	return node

func clear_graph():
	for c in get_children():
		c.queue_free()
	var start_node = start_node_prefab.instantiate()
	add_child(start_node)
