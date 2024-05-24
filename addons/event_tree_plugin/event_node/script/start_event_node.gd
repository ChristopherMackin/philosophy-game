extends EventNode

class_name StartEventNode

func _enter_tree():
	event = StartEvent.new()

func update(connected_events : Array[Event]):
	if connected_events.size() > 0:
		event.next_event = connected_events[0]

