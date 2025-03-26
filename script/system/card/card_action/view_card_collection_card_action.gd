extends CardAction

class_name ViewCardCollectionCardAction

@export var card_collection: CardCollection

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	card_collection.init(caller, player, manager)
	
	var cards = card_collection.get_card_collection()
	
	await player.select(SelectionRequest.new(
		cards,
		Const.SelectionAction.VIEW
	))
