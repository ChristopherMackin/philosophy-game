extends SingleConnectEvent

class_name ConsoleLogEvent

@export var console_text : String

func invoke(event_manager : EventManager):
	print(console_text)
	return next_event
