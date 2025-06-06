extends CollectionFilter

class_name BlackboardSuitsCollectionFilter

@export var key: String = "action_suits"
@export_enum("Include", "Exclude") var filter_mode := 0

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	var suits : Array[Suit]
	suits.assign(manager.blackboard.get_value(key))
	
	if filter_mode == 0:
		return card_array.filter(func(card: Card): return suits.has(card.suit))
	else:
		return card_array.filter(func(card: Card): return !suits.has(card.suit))
