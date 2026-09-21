extends Resource

class_name CardUiFactoryBase

@export var card_ui_factory: CardUiFactory
@export var default_card: PackedScene

func get_card_ui(card: Card) -> PackedScene:
	if !card: return null
	
	var card_ui = card_ui_factory.get_card_ui(card) if card_ui_factory else null
	return card_ui if card_ui else default_card
