extends CardAction

class_name TradeCardCollectionsCardAction

@export var collection_container_1 : CardCollectionContainer
@export var collection_container_2 : CardCollectionContainer

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	collection_container_1.init(caller, player, manager)
	collection_container_2.init(caller, player, manager)
	
	var cards_1 := await collection_container_1.get_collection_cards()
	var cards_2 := await collection_container_2.get_collection_cards()
	
	var size = cards_1.size() if cards_1.size() <= cards_2.size() else cards_2.size()
	
	for i in size:
		var card_1 = cards_1[i]
		var card_2 = cards_2[i]
		
		var index_1 = card_1.collection.get_card_index(card_1)
		var index_2 = card_2.collection.get_card_index(card_2)
		
		var collection_1 = card_1.collection
		var collection_2 = card_2.collection
		
		collection_1.insert(index_1, card_2)
		collection_2.insert(index_2, card_1)
	
	return true
