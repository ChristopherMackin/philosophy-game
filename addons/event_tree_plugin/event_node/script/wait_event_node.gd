@tool
extends EventNode

class_name WaitEventNode

func _enter_tree():
	event = WaitEvent.new()

func update(connected_events : Array[Event]):
	event.wait_time = get_node("SpinBox").value
	
	if connected_events.size() > 0:
		event.next_event = connected_events[0]
