extends EventFactory

class_name OrderedEventFactory

@export var payload_list : Array[EventFactoryPayload]

func get_event(query: Dictionary) -> Event:
	for p in payload_list:
		if !query.has(p.event.resource_path.get_file()) && p.rule.check(query):
			return p.event
	
	return null
