extends CardCollectionContainer

class_name BlackboardCollectionContainer

@export var key : String

func get_collection_cards() -> Array[Card]:
	var array = manager.blackboard.get_value("action.%s" % key)
	return array
