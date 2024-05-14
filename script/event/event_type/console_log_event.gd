extends Event

class_name ConsoleLogEvent

var console_text : String
var next_event : Event

func invoke(event_manager : EventManager):
	print(console_text)
	return next_event
