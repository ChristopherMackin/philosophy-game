extends CardAction

class_name GetSuitsFromCards

@export var cards_key : String = "cards"
@export var suits_key : String = "suits"

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var cards = manager.blackboard.get_value("action.%s" % cards_key)
	var suits: Array[Suit] = []
	
	for selection in cards:
		suits.append(selection.suit)
	
	manager.blackboard.add("action.%s" % suits_key, suits, Const.ExpirationToken.ON_ACTION_END)
	
	return true
