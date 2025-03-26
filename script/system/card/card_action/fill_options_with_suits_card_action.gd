extends CardAction

class_name FillOptionsWithSuitsCardAction

@export var suits : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):	
	manager.blackboard.add("action.options", suits, Const.ExpirationToken.ON_ACTION_END)
	manager.blackboard.add("action.type", Const.SelectionType.SUIT, Const.ExpirationToken.ON_ACTION_END)
	
	return true
