extends Resource

class_name CardUiFactory

@export var card_ui_packed_scene_factory: CardUiPackedSceneFactory
@export var default_scene: PackedScene

func get_card_ui(card: Card, old_card_ui: CardUi = null) -> CardUi:
	if !card: return old_card_ui
	
	var packed_scene = card_ui_packed_scene_factory.get_packed_scene(card) if card_ui_packed_scene_factory else null
	packed_scene = packed_scene if packed_scene else default_scene
	
	if old_card_ui && old_card_ui.packed_scene_name == Util.get_resource_name(packed_scene):
		return old_card_ui
	
	var card_ui: CardUi = packed_scene.instantiate()
	card_ui.packed_scene_name = Util.get_resource_name(packed_scene)
	return card_ui
