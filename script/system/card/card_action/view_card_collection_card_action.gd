extends CardAction

class_name ViewCardCollectionContainerCardAction

@export var collection_container: CardCollectionContainer

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	collection_container.init(caller, player, manager)
	
	var cards = collection_container.get_collection_cards()
	
	await player.select(SelectionRequest.new(
		cards,
		Const.SelectionAction.VIEW
	))
