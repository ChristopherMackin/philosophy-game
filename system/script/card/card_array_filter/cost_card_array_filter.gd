extends CardArrayFilter

class_name CostCardArrayFilter

@export_enum("LessThan", "LessThanEqual", "GreaterThan", "GreaterThanEqual", "Equal", "NotEqual") var filter_mode := 4
@export var cost: int = 0

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:	
	match filter_mode:
		0: return card_array.filter(func(card: Card): return card.cost < cost)
		1: return card_array.filter(func(card: Card): return card.cost <= cost)
		2: return card_array.filter(func(card: Card): return card.cost > cost)
		3: return card_array.filter(func(card: Card): return card.cost <= cost)
		4: return card_array.filter(func(card: Card): return card.cost == cost)
		5: return card_array.filter(func(card: Card): return card.cost != cost)
	
	return []
