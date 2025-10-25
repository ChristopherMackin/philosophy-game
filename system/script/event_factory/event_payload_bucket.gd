extends Resource

class_name EventPayloadBucket

@export var concept : Const.Concept
@export var payload_list : Array[EventFactoryPayload]:
	set(val):
		payload_list = Util.auto_populate_resource_array(payload_list, val, EventFactoryPayload)
