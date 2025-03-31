extends CardAction

class_name ViewCardCollectionCardAction

@export var collection_container: CardCollectionContainer

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	
	var cards = await collection_container.get_collection_cards()
	
	await player.select(SelectionRequest.new(
		cards,
		Const.SelectionAction.VIEW
	))
	
	manager.blackboard.add("action_viewed_cards", cards, Const.ExpirationToken.ON_ACTION_END)
	
	return true
