extends CardAction

class_name ReplaceCardSuitCardAction

@export var cards_key : String = "cards"
@export var suit_key : String = "suit"

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var cards = manager.blackboard.get_value("action.%s" % cards_key)
	var suit = manager.blackboard.get_value("action.%s" % suit_key)[0]
	
	for selection in cards:
		selection.suit = suit
	
	return true
