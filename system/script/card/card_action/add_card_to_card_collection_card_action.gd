extends CardAction

class_name AddCardToCardCollectionCardAction

@export var collection_container : CardCollectionContainer

@export var base : CardBase
@export var amount : int = 1

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	
	for i in amount:
		var card = Card.new(base, manager)
		
		await collection_container.add_card_to_collection(card)
	
	manager.blackboard.add_flag(Flag.ACTION_ADDED_CARD_BASE, base, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true
