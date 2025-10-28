@tool
extends Resource

class_name DeckConfig

@export var base : CardBase:
	set(val):
		base = val
		_set_resource_name()

@export var count : int = 0:
	set(val):
		count = val
		_set_resource_name()


func _init(base : CardBase = null, count : int = 0):
	self.base = base
	self.count = count

func _set_resource_name():
	if!base:
		resource_name = "%s null" % [count]
		return
		
	resource_name = "%s %s" % [count, base.title]
