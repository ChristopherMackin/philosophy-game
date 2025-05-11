extends Resource

class_name CardBaseDropRate

signal value_changed

@export var weight: int = 1:
	set(val):
		weight = val
		if weight < 0: weight = 0

@export var card_base: CardBase:
	set(val):
		card_base = val
