class_name PlayCardCollectionCardAction
extends CardAction

@export var collection_container : CardCollectionContainer
func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	
	for card in await collection_container.get_collection_cards():
		if card.has_token:
			manager.play_token(card.pop_token(), card.suit, player)
	
	return true
