extends CardUiFactory

class_name SuitCardUiFactory

@export var suit: Suit
@export var card_ui_factory: CardUiFactory

func get_card_ui(card: Card) -> PackedScene:
	if !card || card.suit != suit: return
	
	return card_ui_factory.get_card_ui(card)
