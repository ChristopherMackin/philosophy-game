@tool
extends CardAction

class_name MoveCardCollectionContainerToCardCollectionContainerCardAction

@export var from_collection : CardCollectionContainer
@export var to_collection : CardCollectionContainer

func invoke(caller : Card, player : Contestant, manager : DebateManager):	
	from_collection.init(caller, player, manager)
	to_collection.init(caller, player, manager)
	
	var from_collection_cards = from_collection.get_collection_cards()
	
	for card in from_collection_cards:
		to_collection.add_card_to_collection(card)
	
	manager.blackboard.add("action.moved_cards", from_collection_cards, Const.ExpirationToken.ON_ACTION_END)
