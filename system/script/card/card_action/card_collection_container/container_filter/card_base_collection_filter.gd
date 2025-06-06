extends CollectionFilter

class_name CardBaseCollectionFilter

@export var collection: CardCollectionContainer
@export_enum("Include", "Exclude") var filter_mode := 0

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	collection.init(caller, contestant, manager)
	var cards = await collection.get_collection_cards()
	var card_bases = cards.map(func(card): return card.base)
	
	if filter_mode == 0:
		return card_array.filter(func(card: Card): return card_bases.has(card.base))
	else:
		return card_array.filter(func(card: Card): return !card_bases.has(card.base))
