@tool
extends EventNode

class_name ConsoleLogEventNode

func _enter_tree():
	event = ConsoleLogEvent.new()

func update(connected_events : Array[Event]):
	event.console_text = get_node("ConsoleText").text
	
	if connected_events.size() > 0:
		event.next_list = [connected_events[0]]

func set_event(event : Event):
	self.event = event
	get_node("ConsoleText").text = event.console_text
