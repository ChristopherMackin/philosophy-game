extends Event

class_name ConsoleLogEvent

@export var console_text : String

func invoke(event_manager : EventManager):
	print(console_text)
	return next_list[0] if next_list.size() > 0 else null
