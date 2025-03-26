extends CollectionFilter

class_name RandomCollectionFilter

@export var amount : int

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	var amount = self.amount if self.amount <= card_array.size() else card_array.size()
	var ret_array : Array[Card] = []
	
	var dup = card_array.duplicate()
	
	for i in amount:
		ret_array.append(dup.pop_at(randi() % dup.size()))
	
	return ret_array
	
