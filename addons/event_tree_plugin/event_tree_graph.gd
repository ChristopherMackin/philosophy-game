@tool
extends GraphEdit

class_name EventGraph

@export var start_node_packed_scene : PackedScene
@onready var task_node_type_parent = $"../../TaskNodeTypeParent"
@onready var start_node = $StartNode

func _on_delete_nodes_request(nodes):
	for path in nodes:
		var n = get_node(NodePath(path))
		if n != start_node:
			n.queue_free()
		clear_node_connections(path)

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

func update_event_from_graph(event : Event) -> Event:
	#Make new event and add starting event
	if !event:
		event = Event.new()
	
	var start_task
	var tasks : Array[Task]
	
	var start_connections = get_connection_list().filter(func (x):
		return x.from_node == start_node.name
	)
	
	var first_node_name = ""
	if start_connections.size() > 0:
		first_node_name = start_connections[0].to_node
	
	var task_nodes = get_task_nodes()
	
	#Set inputs and outputs for all events
	for node : TaskNode in task_nodes:
		#Get all connections for this event node
		var connections = get_connection_list().filter(func (x):
			return x.from_node == node.name
		)
		
		#Sort by port order
		connections.sort_custom(func (a, b): 
			return a.to_port > b.to_port
		)
		
		#Make an array of the events
		var indexes : Array[int] 
		indexes.assign(connections.map(func(x):
			var task_node = get_node(NodePath(x.to_node))
			return task_nodes.find(task_node)
		))
		
		var task = node.get_task(indexes)
		
		tasks.append(task)
		
		if node.name == first_node_name:
			start_task = task
	
	event.start_task = start_task
	event.tasks = tasks
	
	return event

func load_event_tree(event: Event):
	clear_graph()
	
	if event.tasks.size() <= 0:
		return
	
	var first_node = null;
	var nodes = []
	
	for t in event.tasks:
		var packed_scene
	
		for p : TaskNode in task_node_type_parent.get_children():
			if p.task_action.get_script() == t.action.get_script():
				packed_scene = p
				break
		
		var node : TaskNode = packed_scene.duplicate()
		node.set_node_field_values(t)
		add_child(node)
		nodes.append(node)
		
		if t == event.start_task:
			first_node = node
	
	var from_node_index = 0
	
	for t in event.tasks:
		var slot_index = 0
		for to_node_index in t.outputs:
			connect_node(nodes[from_node_index].name, slot_index, nodes[to_node_index].name, 0)
			slot_index += 1
		from_node_index += 1
	
	connect_node("StartNode", 0, first_node.name,0)
	
	arrange_nodes.call_deferred()

func clear_graph():
	clear_connections()
	
	for c in get_task_nodes():
		c.free()

func get_task_nodes() -> Array[TaskNode]:
	var children = get_children()
	var task_nodes = children.filter(func(node): return node is GraphNode)	
	var index = task_nodes.find(start_node)
	task_nodes.remove_at(index)
	
	var ret: Array[TaskNode] = []
	ret.assign(task_nodes)
	return ret

func _can_drop_data(at_position, data):
	if data is TaskNode:
		return true

func _drop_data(at_position, data):
	var node = data.duplicate()
	add_child(node, true)
	node.position_offset = (scroll_offset + at_position) / zoom
