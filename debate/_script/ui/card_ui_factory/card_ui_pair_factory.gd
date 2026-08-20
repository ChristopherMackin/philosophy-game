extends CardUiFactory

class_name CardUiPairFactory

@export var token_card_gui: PackedScene
@export var tokenless_card_gui: PackedScene

func get_card_ui(card: Card) -> PackedScene:
	if !card: return
	
	return token_card_gui if card.has_token_base else tokenless_card_gui
