extends Resource

class_name EventTree

@export var start_event : Event

@export var events : Array[Event]

func get_event(index : int):
	if range(events.size()).has(index): 
		return events[index]
	else:
		return null
