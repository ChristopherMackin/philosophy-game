@tool
extends GraphNode

class_name EventNode

@export var event_action : EventAction
var event : Event

func make_new_event():
	event = Event.new()
	event.action = event_action

func set_event_connections(connected_events : Array[Event]):
	#Get inputs here
	var inputs = get_children().map(func(x): 
		return ControlHelper.get_value(x)
	)
	
	
	event.set_event_connections(inputs, connected_events)

func set_node_field_values(event : Event):
	var i : int = 0
	for c in get_children():
		ControlHelper.set_value(c, event.get_input(i))
	
