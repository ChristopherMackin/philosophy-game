@tool
extends EventFactory

class_name BucketEventFactory

@export var buckets: Array[EventFactory]

func get_event(_query: Dictionary) -> Event:
	for bucket in buckets:
		var event = bucket.get_event(_query)
		if event != null:
			return event
	
	return null
