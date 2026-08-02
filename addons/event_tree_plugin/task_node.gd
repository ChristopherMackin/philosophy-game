@tool
extends GraphNode

class_name TaskNode

@export var task_action : TaskAction

func get_task(connection_indexes : Array[int]):
	var task = Task.new()
	task.action = task_action
	
	var inputs: Dictionary[String, Variant]
	for c in Util.get_all_children(self):
		if !c is TaskNodeField:
			continue
		
		inputs[c.field_name] = ControlHelper.get_value(c)
	
	task.set_event_connections(inputs, connection_indexes)
	
	return task

func set_node_field_values(task : Task):
	for c in Util.get_all_children(self):
		if !c is TaskNodeField:
			continue
		print(task.get_input(c.field_name))
		ControlHelper.set_value(c, task.get_input(c.field_name))
