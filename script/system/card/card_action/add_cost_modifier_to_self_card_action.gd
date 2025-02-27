extends CardAction

class_name AddCostModifierToSelfCardAction

@export var cost_modifier : CardCostModifier

func invoke(card : Card, player : Contestant, manager : DebateManager):
	card.cost_modifiers.append(cost_modifier)

