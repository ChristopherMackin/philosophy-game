@tool
extends GraphNode

class_name TaskNode

@export var task_action : TaskAction

func get_task(connection_indexes : Array[int]):
	var task = Task.new()
	task.action = task_action
	
	var inputs = get_children().map(func(x):
		if !x is Control:
			return
		
		return ControlHelper.get_value(x)
	)
	
	task.set_event_connections(inputs, connection_indexes)
	
	return task

func set_node_field_values(task : Task):
	var i : int = 0
	
	for c in get_children():
		if !c is Control:
			continue
		ControlHelper.set_value(c, task.get_input(i))
		i += 1
