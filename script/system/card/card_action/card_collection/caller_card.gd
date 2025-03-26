extends CardCollection

class_name CallerCard

func get_card_collection() -> Array[Card]:
	return [caller]

func remove_card_from_collection(card: Card) -> bool:
	return player.remove_from_hand(card)
