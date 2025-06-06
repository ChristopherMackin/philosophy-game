extends CollectionFilter

class_name PerTagCollectionFilter

@export_enum("Forwards", "Backwards") var slice_direction := 0
@export var amount_per_tag: float
@export var tag: Const.Tag

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	var tag_count = 0
	for key in manager.suit_track_dictionary:
		tag_count += manager.suit_track_dictionary[key]\
		.filter(func(x): return x.tag == tag).size()
	
	var amount = floor(tag_count * amount_per_tag)
	amount = amount if amount <= card_array.size() else card_array.size()
	
	var ret_array
	
	match slice_direction:
		0:
			ret_array = card_array.slice(0, amount)
		1:
			ret_array = card_array.slice(0, -amount, -1)
	
	return ret_array
	
