extends Event

class_name SingleConnectEvent

@export var next_event : Event

func invoke(manager : EventManager):
	return next_event
