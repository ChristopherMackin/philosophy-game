extends CardCollectionContainer

class_name CallerCollectionContainer

func _get_unfiltered_collection() -> Array[Card]:
	return [caller]

func add_card_to_collection(card: Card):
	caller.collection.push_back(card)
