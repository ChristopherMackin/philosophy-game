extends CardAction

class_name StoreCardCollectionSuitsInBlackboardCardAction

@export var collection_container : CardCollectionContainer
@export var key: String = "suits"

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_collection_cards()
	
	if cards.size() <= 0: return true
	
	var suits = cards.map(func(card): return card.suit)
	
	manager.blackboard.add("action_%s" % key, suits, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true
