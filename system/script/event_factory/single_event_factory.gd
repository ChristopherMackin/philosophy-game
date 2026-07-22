@tool
extends EventFactory

class_name SingleEventFactory

@export var event: Event

func get_event(_query: Dictionary) -> Event:
	return event
