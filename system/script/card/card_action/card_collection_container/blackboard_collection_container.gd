extends CardCollectionContainer

class_name BlackboardCollectionContainer

@export var key : String = "action_cards"

func _get_unfiltered_collection() -> Array[Card]:
	var array = manager.blackboard.get_value(key)
	return array

func add_card_to_collection(card: Card):
	if manager.blackboard.has(key):
		var array = manager.blackboard.get_value(key)
		var expiration = manager.blackboard.get_expiration_token(key)
		array.append(card)
		manager.blackboard.add(key, array, expiration)
	else:
		manager.blackboard.add(key, [card])
