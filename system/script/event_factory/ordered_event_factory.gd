@tool
extends EventFactory

class_name OrderedEventFactory

@export var payload_list : Array[EventFactoryPayload]:
	set(val):
		payload_list = Util.auto_populate_resource_array(payload_list, val, EventFactoryPayload, "New Factory Payload")

func get_event(query: Dictionary) -> Event:
	for p in payload_list:
		if !query.has(p.event.resource_path.get_file()) && p.rule.check(query):
			return p.event
	
	return null
