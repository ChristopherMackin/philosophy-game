@tool
extends GraphNode

class_name EventNode

var event : Event

func update(connected_events : Array[Event]):
	pass

func set_event(event : Event):
	self.event = event
