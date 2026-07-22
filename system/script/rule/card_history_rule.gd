@tool
extends Rule

class_name CardHistoryRule

@export var card_history: Array[CardBase]

func check(_query : Dictionary) -> bool:
	if !_query.has("card_history"): return false
	if card_history.size() > _query["card_history"].size(): return false
	
	var valid := true
	
	for i in card_history.size():
		if card_history[i] != _query["card_history"][i].base:
			valid = false
			break
	
	return valid
