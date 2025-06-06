extends CollectionFilter

class_name UniqueDuplicatesCollectionFilter

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	var saved_cards : Array[Card] = []
	
	for card in card_array:
		if saved_cards.find_custom(func(saved_card: Card): return card.equals(saved_card)) == -1:
			saved_cards.append(card)
	
	return saved_cards
