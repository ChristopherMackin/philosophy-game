extends CardAction

class_name Boost

@export var boost_amount : int = 1

func positive_action(manager: DebateManager):
	var suit = manager.current_suit
	manager.increase_suit_score(suit, boost_amount)

func negative_action(manager: DebateManager):
	var suit = manager.current_suit
	manager.increase_suit_score(suit, -1)
