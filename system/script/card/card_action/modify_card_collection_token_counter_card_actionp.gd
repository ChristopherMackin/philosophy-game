extends CardAction

class_name ModifyCardCollectionTokenCounterCardAction

@export var collection: CardCollectionContainer
@export var amount : int = 1
@export var operation: EnumMath.Operation

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection.init(caller, player, manager)
	var card_array = await collection.get_collection_cards()
	
	for card in card_array:
		var new_counter = EnumMath.evaluate(card.base_token_counter, amount, operation)
		card.base_token_counter = new_counter
	
	return true
