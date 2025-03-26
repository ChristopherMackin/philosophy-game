extends CollectionFilter

class_name SuitCollectionFilter

@export var suits: Array[Suit]

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	return card_array.filter(func(card: Card): return suits.has(card.suit))
