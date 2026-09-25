extends CardUiPackedSceneFactory

class_name RuleCardUiPackedSceneFactory

@export var rule: Rule
@export var bb: Blackboard
@export var card_ui_packed_scene_factory: CardUiPackedSceneFactory

func get_packed_scene(card: Card) -> PackedScene:
	if !card || !rule || !rule.check(bb.get_query()): return
	
	return card_ui_packed_scene_factory.get_packed_scene(card)
