extends CardUiPackedSceneFactory

class_name SuitCardUiPackedSceneFactory

@export var suit: Suit
@export var card_ui_packed_scene_factory: CardUiPackedSceneFactory

func get_packed_scene(card: Card) -> PackedScene:
	if !card || card.suit != suit: return
	
	return card_ui_packed_scene_factory.get_packed_scene(card)
