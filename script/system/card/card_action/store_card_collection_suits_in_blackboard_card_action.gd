extends CardAction

class_name StoreCardCollectionSuitsInBlackboardCardAction

@export var collection_container : CardCollectionContainer
@export var key: String = "suits"

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_collection_cards()
	var suits = cards.map(func(card): return card.suit)
	
	manager.blackboard.add("action_%s" % key, suits, Const.ExpirationToken.ON_ACTION_END)
	
	return true
