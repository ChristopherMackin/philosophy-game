@tool
extends CardAction

class_name DuplicateCardCollectionToCardCollectionCardAction

@export var from_collection: CardCollectionContainer
@export var to_collection: CardCollectionContainer
@export var keep_status_effect:= false

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	from_collection.init(caller, player, manager)
	to_collection.init(caller, player, manager)
	
	var from_collection_cards = await from_collection.get_collection_cards()
	
	for card: Card in from_collection_cards:
		to_collection.add_card_to_collection(card.duplicate(keep_status_effect))
	
	manager.blackboard.add_flag(Flag.ACTION_DUPLICATE_CARDS_FROM, from_collection_cards, Blackboard.ExpirationToken.ON_ACTION_END)
	manager.blackboard.add_flag(Flag.ACTION_DUPLICATE_CARDS_TO, to_collection, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true
