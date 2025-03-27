extends CardAction

class_name BanishCardCollectionContainerCardAction

@export var collection_container : CardCollectionContainer
@export var which_contestant : Const.WhichContestant

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_card_collection()
	
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	for card in cards:
		contestant.remove_from_deck(card)
		await card.card_collection.remove(card)
