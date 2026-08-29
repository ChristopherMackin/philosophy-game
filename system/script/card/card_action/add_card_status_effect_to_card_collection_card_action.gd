extends CardAction

class_name AddCardStatusEffectToCardCollectionCardAction

@export var collection_container: CardCollectionContainer 
@export var status_effect : CardStatusEffect

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_collection_cards()
	
	for card: Card in cards:
		status_effect.apply(card)
	
	manager.blackboard.add("action_added_card_status_effect", status_effect, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true
