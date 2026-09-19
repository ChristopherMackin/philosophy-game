extends CardArrayFilter

class_name CostOrderCardArrayFilter

@export_enum("Ascending", "Descending") var filter_mode:= 0
@export_enum("BaseCost", "CurrentCost") var cost_origin:= 0

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:	
	match cost_origin:
		0:
			if filter_mode == 0: 
				card_array.sort_custom(func(x: Card, y: Card): return x.base_cost < y.base_cost)
				return card_array
			else: 
				card_array.sort_custom(func(x: Card, y: Card): return x.base_cost > y.base_cost)
				return card_array
		1:
			if filter_mode == 0: 
				card_array.sort_custom(func(x: Card, y: Card): return x.cost < y.cost)
				return card_array
			else: 
				card_array.sort_custom(func(x: Card, y: Card): return x.cost > y.cost)
				return card_array
	
	return []
