extends CollectionFilter

class_name RemoveDuplicatesCollectionFilter

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	var cards : Array[Card] = []
	var bases : Array[CardBase] = []
	
	for card in card_array:
		if !bases.has(card.base):
			cards.append(card)
			bases.append(card.base)
	
	return cards
