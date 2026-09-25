extends CardUiPackedSceneFactory

class_name BucketCardUiPackedSceneFactory

@export var buckets: Array[CardUiPackedSceneFactory]

func get_packed_scene(card: Card) -> PackedScene:
	for bucket in buckets:
		var card_ui = bucket.get_packed_scene(card)
		if card_ui != null:
			return card_ui
	
	return null
