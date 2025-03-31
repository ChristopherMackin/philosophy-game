extends CardAction

class_name BanishCardCollectionCardAction

@export var collection_container : CardCollectionContainer
@export var which_contestant : Const.WhichContestant

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_card_collection()
	
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	for card in cards:
		contestant.remove_from_deck(card)
		await card.card_collection.remove(card)
	
	manager.blackboard.add("action_banished_cards", cards, Const.ExpirationToken.ON_ACTION_END)
	
	return true
