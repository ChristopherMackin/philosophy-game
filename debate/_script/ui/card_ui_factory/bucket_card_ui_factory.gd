extends CardUiFactory

class_name BucketCardUiFactory

@export var buckets: Array[CardUiFactory]

func get_card_ui(card: Card) -> PackedScene:
	for bucket in buckets:
		var card_ui = bucket.get_card_ui(card)
		if card_ui != null:
			return card_ui
	
	return null
