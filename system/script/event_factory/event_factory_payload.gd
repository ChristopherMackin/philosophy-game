@tool
extends Resource

class_name EventFactoryPayload

@export var event : Event:
	set(val):
		event = val
		resource_name = Util.get_resource_name(event)
@export var rule : Rule = Rule.new()
