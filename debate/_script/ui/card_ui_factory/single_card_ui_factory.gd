extends CardUiFactory

class_name SingleCardUiFactory

@export var card_ui: PackedScene

func get_card_ui(card: Card) -> PackedScene:
	if !card: return
	
	return card_ui
