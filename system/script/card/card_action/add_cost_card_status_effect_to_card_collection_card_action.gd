extends CardAction

class_name AddCostCardStatusEffectToCardCollectionCardAction

@export var collection_container: CardCollectionContainer 
@export var cost_modifier : CostCardStatusEffect

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_collection_cards()
	
	for card: Card in cards:
		cost_modifier.apply(card)
	
	manager.blackboard.add("action_added_cost_modifier", cost_modifier, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true
