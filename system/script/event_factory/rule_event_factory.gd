@tool
extends EventFactory

class_name RuleEventFactory

@export var rule: Rule
@export var event: Event

func get_event(_query: Dictionary) -> Event:
	if !rule || (!_query.has(event.resource_path.get_file()) && rule.check(_query)):
		return event
	
	return null
