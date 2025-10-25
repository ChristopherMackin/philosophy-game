@tool
extends Resource

class_name DeckConfig

@export var base : CardBase:
	set(val):
		base = val
		if !base: 
			resource_name = "Null"
			return
		
		resource_name = base.title
@export var count : int

func _init(base : CardBase = null, count : int = 0):
	self.base = base
	self.count = count
