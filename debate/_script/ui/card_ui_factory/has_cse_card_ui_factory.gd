class_name HasCseCardUIFactory
extends CardUiFactory

@export var card_status_effect: CardStatusEffect
@export var card_ui_factory: CardUiFactory

func get_card_ui(card: Card) -> PackedScene:
	if card.status_effects.values.find_custom(func(x): 
		return card_status_effect.name == x.name
		) != -1:
		return card_ui_factory.get_card_ui(card)
	
	return null
