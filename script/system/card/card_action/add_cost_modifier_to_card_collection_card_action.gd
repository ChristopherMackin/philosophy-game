extends CardAction

class_name AddCostModifierToCardCollectionContainerCardAction

@export var collection_container: CardCollectionContainer 
@export var cost_modifier : CardCostModifier

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_collection_container()
	
	for card in cards:
		card.cost_modifiers.append(cost_modifier.duplicate(true))
	
	manager.blackboard.add("action.added_cost_modifier", cost_modifier, Const.ExpirationToken.ON_ACTION_END)
