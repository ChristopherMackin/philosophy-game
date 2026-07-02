@tool
extends EventFactory

class_name OrderedBucketEventFactory

@export var buckets: Array[EventPayloadBucket]:
	set(val):
		buckets = Util.auto_populate_resource_array(buckets, val, EventPayloadBucket, "Event Payload Bucket")

func get_event(query: Dictionary) -> Event:
	var payload_list: Array[EventFactoryPayload]
	
	for bucket in buckets:
		if bucket.rule.check(query):
			payload_list = bucket.payload_list
			break
	
	if !payload_list: return null
	
	for p in payload_list:
		if !query.has(p.event.resource_path.get_file()):
			if !p.rule || p.rule.check(query):
				return p.event
	
	return null
