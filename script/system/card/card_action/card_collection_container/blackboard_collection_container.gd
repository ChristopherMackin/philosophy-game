extends CardCollectionContainer

class_name BlackboardCollectionContainer

@export var key : String

func _get_unfiltered_collection() -> Array[Card]:
	var array = manager.blackboard.get_value("action.%s" % key)
	return array
