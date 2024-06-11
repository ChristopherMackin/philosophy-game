extends CardAction

class_name Boost

@export var boost_amount : int = 1

func positive_action(manager: DebateManager):
	var suit = manager.current_suit
	manager.suit_score_dictionary[suit.name] += 1

func negative_action(manager: DebateManager):
	var suit = manager.current_suit
	manager.suit_score_dictionary[suit.name] -= 1
