extends Control

class_name HoldAreaGUI

@export_group("Packed Scene")
@export var default_card_gui_packed_scene: PackedScene
@export var default_tokenless_card_gui_packed_scene: PackedScene

@export var card_gui_suit_packed_scenes : Array[SuitPackedScene]
@export var tokenless_card_gui_suit_packed_scenes : Array[SuitPackedScene]

var held_card : CardGUI = null

func set_hold_card(card: Card):
	if held_card:
		held_card.queue_free()
		held_card = null
	
	if card == null:
		get_parent().visible = false
		return
	else:
		get_parent().visible = true
	
	var card_gui_packed_scene = get_card_gui_packed_scene(card)
	
	var card_gui : CardGUI = card_gui_packed_scene.instantiate() as CardGUI
	card_gui.card = card
	
	add_child(card_gui)
	
	held_card = card_gui

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
