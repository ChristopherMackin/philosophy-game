extends TopCostModifier

class_name MinusTagCostModifier

@export var tag : Constants.Tag

func modify_cost(cost : int) -> int:
	var new_cost = cost - \
	manager.top_queue_dictionary[top_data.pose.name]\
	.filter(func(x): return x.data.tags.has(tag)).size()
	
	if new_cost < 0: new_cost = 0
	
	return new_cost
