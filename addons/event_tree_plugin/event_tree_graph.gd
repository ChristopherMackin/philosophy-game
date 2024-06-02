@tool
extends GraphEdit

class_name EventGraph

@export var start_node_prefab : PackedScene
@onready var task_node_type_parent = $"../TaskNodeTypeParent"
@onready var start_node = $StartNode

func _on_delete_nodes_request(nodes):
	for name in nodes:
		var n = get_node(NodePath(name))
		if n != start_node:
			n.queue_free()
		clear_node_connections(name)

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

func clear_node_connections(node):
	var connections = get_connection_list().filter(func (x):
		return x.from_node == node || x.to_node == node
	)
	for c in connections:
		disconnect_node(c.from_node, c.from_port, c.to_node, c.to_port)

func get_event_from_graph() -> Event:
	#Make new event and add starting event
	var event = Event.new()
	
	var start_connections = get_connection_list().filter(func (x):
		return x.from_node == start_node.name
	)
	
	if start_connections.size() <= 0:
		return event
		
	var first_node_name = start_connections[0].to_node
	
	#Set inputs and outputs for all events
	for node : TaskNode in get_task_nodes():
		#Get all connections for this event node
		var connections = get_connection_list().filter(func (x):
			return x.from_node == node.name
		)
		
		#Sort by port order
		connections.sort_custom(func (a, b): 
			return a.from_port > b.from_port
		)
		
		#Make an array of the events
		var indexes : Array[int] 
		indexes.assign(connections.map(func(x):
			return get_node(NodePath(x.to_node)).get_index() - 1
		))
		
		var task = node.get_task(indexes)
		
		event.tasks.append(task)
		
		if node.name == first_node_name:
			event.start_task = task
	
	return event

func load_event_tree(event: Event):
	clear_graph()
	
	if event.tasks.size() <= 0:
		return
	
	var first_node = null;
	
	for t in event.tasks:
		var prefab
	
		for p : TaskNode in task_node_type_parent.get_children():
			if p.task_action.get_script() == t.action.get_script():
				prefab = p
				break
		
		var node : TaskNode = prefab.duplicate()
		node.set_node_field_values(t)
		add_child(node)
		
		if t == event.start_task:
			first_node = node
	
	
	var event_nodes = get_task_nodes();
	var from_node_index = 0
	
	for t in event.tasks:
		var slot_index = 0
		for to_node_index in t.outputs:
			connect_node(event_nodes[from_node_index].name, slot_index, event_nodes[to_node_index].name, 0)
			slot_index += 1
		from_node_index += 1
	
	connect_node("StartNode", 0, first_node.name,0)
	
	arrange_nodes()

func clear_graph():
	for c in get_children():
		if c != start_node:
			c.queue_free()

func get_task_nodes():
	var task_nodes = get_children()
	var index = task_nodes.find(start_node)
	task_nodes.remove_at(index)
	return task_nodes
