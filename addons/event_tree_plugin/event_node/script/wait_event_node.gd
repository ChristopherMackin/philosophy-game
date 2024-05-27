@tool
extends EventNode

class_name WaitEventNode

func _enter_tree():
	event = WaitEvent.new()

func update(connected_events : Array[Event]):
	event.wait_time = get_node("SpinBox").value
	
	if connected_events.size() > 0:
		event.next_list = [connected_events[0]]

func set_event(event : Event):
	self.event = event
	get_node("SpinBox").value = event.wait_time
