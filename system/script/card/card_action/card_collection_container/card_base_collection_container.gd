extends CardCollectionContainer

class_name CardBaseCollectionContainer

@export var CardBaseArray: Array[CardBase] = []

func _get_unfiltered_collection() -> Array[Card]:
	var cards: Array[Card] 
	cards.assign(CardBaseArray.map(func(x: CardBase): return Card.new(x, manager)))
	return cards
