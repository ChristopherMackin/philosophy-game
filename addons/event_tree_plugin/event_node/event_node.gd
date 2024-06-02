@tool
extends GraphNode

class_name EventNode

@export var event_action : EventAction

func get_event(connection_indexes : Array[int]):
	var event = Event.new()
	event.action = event_action
	
	#Get inputs here
	var inputs = get_children().map(func(x): 
		return ControlHelper.get_value(x)
	)
	
	event.set_event_connections(inputs, connection_indexes)
	
	return event

func set_node_field_values(event : Event):
	var i : int = 0
	
	for c in get_children():
		ControlHelper.set_value(c, event.get_input(i))
		i += 1
	
