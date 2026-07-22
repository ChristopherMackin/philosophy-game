@tool
extends BucketEventFactory

class_name RuleBucketEventFactory

@export var rule: Rule

func get_event(_query: Dictionary) -> Event:
	if rule.check(_query):
		return super.get_event(_query)
	
	return null
