@tool
extends Rule

class_name CardHistoryRule

@export var card_history: Array[CardBase]

func check(_query : Dictionary) -> bool:
	var key = Flag.name(Flag.CARD_HISTORY)
	
	if !_query.has(key): return false
	if card_history.size() > _query[key].size(): return false
	
	var valid := true
	
	for i in card_history.size():
		if card_history[i] != _query[key][i].base:
			valid = false
			break
	
	return valid
