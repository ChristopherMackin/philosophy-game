extends CardAction

class_name AddCardStatusEffectToCardCollectionCardAction

@export var collection_container: CardCollectionContainer 
@export var status_effect : CardStatusEffect

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_collection_cards()
	
	for card: Card in cards:
		status_effect.apply(card)
	
	manager.blackboard.add_flag(Flag.ACTION_ADDED_CARD_STATUS_EFFECT, status_effect, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true
