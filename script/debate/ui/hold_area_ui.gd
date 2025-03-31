extends Control

class_name HoldAreaUI

@export_group("Packed Scene")
@export var default_card_ui_packed_scene: PackedScene
@export var default_tokenless_card_ui_packed_scene: PackedScene

@export var card_ui_suit_packed_scenes : Array[SuitPackedScene]
@export var tokenless_card_ui_suit_packed_scenes : Array[SuitPackedScene]

var held_card : CardUI = null

func set_hold_card(card: Card):
	if held_card:
		held_card.queue_free()
		held_card = null
	
	if card == null: return
	
	var card_ui_packed_scene = get_card_ui_packed_scene(card)
	
	var card_ui : CardUI = card_ui_packed_scene.instantiate() as CardUI
	card_ui.card = card
	
	add_child(card_ui)
	
	held_card = card_ui

func get_card_ui_packed_scene(card: Card) -> PackedScene:
	var card_ui_packed_scene
	
	if card.has_token_base:
		var index = card_ui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
		if index < 0:
			card_ui_packed_scene = default_card_ui_packed_scene
		else:
			card_ui_packed_scene = card_ui_suit_packed_scenes[index].packed_scene
	else:
		var index = tokenless_card_ui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
		if index < 0:
			card_ui_packed_scene = default_tokenless_card_ui_packed_scene
		else:
			card_ui_packed_scene = tokenless_card_ui_suit_packed_scenes[index].packed_scene
	
	return card_ui_packed_scene
