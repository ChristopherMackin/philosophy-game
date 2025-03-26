extends CardAction

class_name AddCardModifierToSelectedCardsCardAction

@export var cost_modifier : CardCostModifier

@export var key : String = "selection"

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var selected_cards = manager.blackboard.get_value("action.%s" % key)
	
	for selected_card in selected_cards:
		selected_card.cost_modifiers.append(cost_modifier.duplicate(true))
	
	return true
