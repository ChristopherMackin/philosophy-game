extends CardUiPackedSceneFactory

class_name SingleCardUiPackedSceneFactory

@export var card_ui: PackedScene

func get_packed_scene(card: Card) -> PackedScene:
	if !card: return
	
	return card_ui
