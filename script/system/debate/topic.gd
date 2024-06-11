extends Resource

class_name Topic

@export var name : String
@export var suits : Array[Suit]

func has_suit(suit):
	return suits.has(suit)
