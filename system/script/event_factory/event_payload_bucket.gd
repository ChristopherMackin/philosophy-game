@tool
extends Resource

class_name EventPayloadBucket

@export var rule : Rule:
	set(val):
		if rule and rule.on_rule_editor_updated.is_connected(_update_resource_name):
			rule.disconnect("on_rule_editor_updated", _update_resource_name)
		
		rule = val
		
		if rule and !rule.on_rule_editor_updated.is_connected(_update_resource_name):
			rule.connect("on_rule_editor_updated", _update_resource_name)

@export var payload_list : Array[EventFactoryPayload]:
	set(val):
		payload_list = Util.auto_populate_resource_array(payload_list, val, EventFactoryPayload)

func _update_resource_name(name: String):
	resource_name = name
