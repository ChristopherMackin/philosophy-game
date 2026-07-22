@tool
extends EventFactory

class_name RuleEventFactory

@export var rule: Rule
@export var event: Event

func get_event(_query: Dictionary) -> Event:
	if rule.check(_query):
		return event
	
	return null
