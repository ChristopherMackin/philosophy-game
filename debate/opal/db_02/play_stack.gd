extends Node

class_name PlayStack

@export_group("Positioning")
@export var offset: Vector3

@export_group("Packed Scene")
@export var default_card_gui_packed_scene: PackedScene
@export var default_tokenless_card_gui_packed_scene: PackedScene

@export var card_gui_suit_packed_scenes : Array[SuitPackedScene]
@export var tokenless_card_gui_suit_packed_scenes : Array[SuitPackedScene]

@export var card_3d: PackedScene

var cards_3d: Array[Card3d] = []

func add_card_to_play_stack(card):
	var instance: Card3d = card_3d.instantiate()
	add_child(instance)
	var cgps = get_card_gui_packed_scene(card)
	instance.init(card, cgps)
	instance.position += offset * cards_3d.size()
	cards_3d.append(instance)

func get_card_gui_packed_scene(card: Card) -> PackedScene:
	var card_gui_packed_scene
	
	if card.has_token_base:
		var index = card_gui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
		if index < 0:
			card_gui_packed_scene = default_card_gui_packed_scene
		else:
			card_gui_packed_scene = card_gui_suit_packed_scenes[index].packed_scene
	else:
		var index = tokenless_card_gui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
		if index < 0:
			card_gui_packed_scene = default_tokenless_card_gui_packed_scene
		else:
			card_gui_packed_scene = tokenless_card_gui_suit_packed_scenes[index].packed_scene
	
	return card_gui_packed_scene
