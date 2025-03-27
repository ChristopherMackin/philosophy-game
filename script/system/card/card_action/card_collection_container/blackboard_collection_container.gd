extends CardCollectionContainer

class_name BlackboardCollectionContainer

@export var key : String

func get_collection_cards() -> Array[Card]:
	return manager.blackboard.get_value(key)
