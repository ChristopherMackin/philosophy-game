extends EventFactory

class_name OrderedEventFactory

@export var payload_list : Array[EventFactoryPayload]

func get_event(query: Dictionary) -> Event:
	for p in payload_list:
		if p.rule.check(query):
			return p.event
	
	return null
