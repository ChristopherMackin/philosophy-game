@tool
extends CardCostModifier

class_name MinusTagCardCostModifier

@export var tag : Const.Tag

func modify_cost(base_cost : int, manager : DebateManager) -> int:
	var tag_count = 0
	for key in manager.suit_track_dictionary:
		tag_count += manager.suit_track_dictionary[key]\
		.filter(func(x): return x.tag == tag).size()
	
	var new_cost = base_cost - tag_count
	
	if new_cost < 0: new_cost = 0
	
	return new_cost
