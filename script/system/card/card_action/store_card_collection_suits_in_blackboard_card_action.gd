extends CardAction

class_name StoreCardCollectionSuitsInBlackboardCardAction

@export var card_collection : CardCollection
@export var key: String = "suits"

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	card_collection.init(caller, player, manager)
	var cards = await card_collection.get_card_collection()
	var suits = cards.map(func(card): return card.suit)
	
	for card in cards:
		manager.blackboard.add("action.%s" % key, suits, Const.ExpirationToken.ON_ACTION_END)
