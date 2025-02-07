extends TopCostModifier

class_name MinusTagCostModifier

@export var tag : Constants.Tag

func modify_cost(cost : int) -> int:
	var new_cost = cost - \
	manager.pose_track_dictionary[top_data.pose.name]\
	.filter(func(x): return x.data.tag == tag).size()
	
	if new_cost < 0: new_cost = 0
	
	return new_cost
