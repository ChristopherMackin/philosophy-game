extends PlayableCardFilterEffect

class_name CardSliceFilterEffect

@export_enum("Forwards", "Backwards") var slice_direction := 0
@export var amount: int = 1

func filter(cards: Array[Card]) -> Array[Card]:
	var ret_array: Array[Card] = []
	match slice_direction:
		0:
			ret_array = cards.slice(0, amount)
		1:
			ret_array = cards.slice(0, -amount, -1)
	
	return ret_array
