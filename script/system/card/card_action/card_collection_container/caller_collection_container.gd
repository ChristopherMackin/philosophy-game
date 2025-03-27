extends CardCollectionContainer

class_name CallerCollectionContainer

func get_collection_cards() -> Array[Card]:
	return [caller]

func add_card_to_collection(card: Card):
	caller.collection.push_back(card)
