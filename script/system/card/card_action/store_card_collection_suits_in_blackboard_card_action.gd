extends CardAction

class_name StoreCardCollectionContainerSuitsInBlackboardCardAction

@export var collection_container : CardCollectionContainer
@export var key: String = "suits"

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_card_collection()
	var suits = cards.map(func(card): return card.suit)
	
	for card in cards:
		manager.blackboard.add("action.%s" % key, suits, Const.ExpirationToken.ON_ACTION_END)
