extends CollectionFilter

class_name SliceCollectionCountCollectionFilter

@export var collection: CardCollectionContainer
@export_enum("Forwards", "Backwards") var slice_direction := 0

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	collection.init(caller, contestant, manager)
	
	var amount = (await collection.get_collection_cards()).size()
	var ret_array
	
	match slice_direction:
		0:
			ret_array = card_array.slice(0, amount)
		1:
			ret_array = card_array.slice(0, -amount, -1)
	
	return ret_array
	
