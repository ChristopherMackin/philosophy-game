extends CollectionFilter

class_name SliceCollectionFilter

@export_enum("Forwards", "Backwards") var slice_direction := 0
@export var amount : int

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	var amount = self.amount if self.amount <= card_array.size() else card_array.size()
	var ret_array
	
	match slice_direction:
		0:
			ret_array = card_array.slice(0, amount)
		1:
			ret_array = card_array.slice(0, -amount, -1)
	
	return ret_array
	
