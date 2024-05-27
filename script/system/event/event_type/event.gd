extends Resource

class_name Event

@export var next_list : Array[Event] = []

func invoke(event_manager : EventManager) -> Event:
	print("INVOKED")
	return null
