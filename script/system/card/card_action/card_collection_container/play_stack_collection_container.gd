extends CardCollectionContainer

class_name PlayStackCollectionContainer

func _get_unfiltered_collection() -> Array[Card]:
	return manager.play_stack.get_cards()

func add_card_to_collection(card: Card):
	await manager.play_stack.push_front(card)
