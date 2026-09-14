extends CardAction

class_name SelectAndStoreSuitsInBlackboardCardAction

@export var key: String = "suits"
@export var suit_options: Array[Suit]
@export_enum("Single:1", "Multi:2", "All:3", "First:4") var suit_selection_action := 1
var suit_action: Const.SelectionAction:
	get(): return suit_selection_action as Const.SelectionAction

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	#TODO: Flesh this sucker out
	return true
