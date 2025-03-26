extends CardAction

class_name AddCostModifierToCardCollectionCardAction

@export var card_collection: CardCollection 
@export var cost_modifier : CardCostModifier

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	card_collection.init(caller, player, manager)
	var cards = await card_collection.get_card_collection()
	
	for card in cards:
		card.cost_modifiers.append(cost_modifier.duplicate(true))
