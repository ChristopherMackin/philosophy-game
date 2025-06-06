extends CardCollectionContainer

class_name BlackboardCollectionContainer

@export var key : String = "action_cards"

func _get_unfiltered_collection() -> Array[Card]:
	var array = manager.blackboard.get_value(key)
	return array
