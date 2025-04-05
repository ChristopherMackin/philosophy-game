extends CardAction

class_name StoreCardCollectionInBlackboardCardAction

@export var collection_container : CardCollectionContainer
@export var key: String = "cards"

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_collection_cards()
	
	manager.blackboard.add("action_%s" % key, cards, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true
