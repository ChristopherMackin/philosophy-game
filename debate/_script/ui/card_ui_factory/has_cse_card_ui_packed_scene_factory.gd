class_name HasCseCardUiPackedSceneFactory
extends CardUiPackedSceneFactory

@export var card_status_effect: CardStatusEffect
@export var card_ui_packed_scene_factory: CardUiPackedSceneFactory

func get_packed_scene(card: Card) -> PackedScene:
	if card.status_effects.values.find_custom(func(x): 
		return card_status_effect.name == x.name
		) != -1:
		return card_ui_packed_scene_factory.get_packed_scene(card)
	
	return null
