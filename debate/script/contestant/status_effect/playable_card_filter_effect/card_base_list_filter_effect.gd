extends PlayableCardFilterEffect

class_name CardBaseListFilterEffect

@export_enum("Include", "Exclude") var slice_direction := 0
@export var card_bases: Array[CardBase]

func filter(cards: Array[Card]) -> Array[Card]:
	var ret_array: Array[Card] = []
	
	match slice_direction:
		0:
			ret_array = cards.filter(func(x: Card): return card_bases.has(x.base))
		1:
			ret_array = cards.filter(func(x: Card): return !card_bases.has(x.base))
	
	return ret_array
