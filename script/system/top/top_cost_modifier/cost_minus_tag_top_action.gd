extends TopCostModifier

class_name MinusTagCostModifier

@export var tag : Constants.Tag

func modify_cost(base_cost : int, manager : DebateManager) -> int:
	var tag_count = 0
	for key in manager.pose_track_dictionary:
		tag_count += manager.pose_track_dictionary[key]\
		.filter(func(x): return x.data.tag == tag).size()
	
	var new_cost = base_cost - tag_count
	
	if new_cost < 0: new_cost = 0
	
	return new_cost
