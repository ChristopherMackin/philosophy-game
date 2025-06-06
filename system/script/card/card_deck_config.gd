extends Resource

class_name DeckConfig

@export var base : CardBase
@export var count : int

func _init(base : CardBase = null, count : int = 0):
	self.base = base
	self.count = count
