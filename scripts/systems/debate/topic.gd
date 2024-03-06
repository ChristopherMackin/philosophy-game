extends Resource

class_name Topic

@export var name : String
@export var positive_suit : Suit
@export var negative_suit : Suit

func has_suit(suit):
	match suit:
		positive_suit, negative_suit:
			return true
		_:
			return false

func suit_direction(suit) -> float:
	if not has_suit(suit):
		return 0
	elif suit == positive_suit:
		return 1
	else:
		return -1
