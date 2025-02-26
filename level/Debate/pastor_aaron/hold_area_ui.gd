extends Control

class_name HoldAreaUI

@export var card_ui_suit_packed_scenes : Array[SuitPackedScene]
var held_card : CardUI = null

func set_hold_card(card: Card):
	if held_card:
		held_card.queue_free()
	
	var index = card_ui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
	index = index if index >= 0 else 0
	var card_ui_packed_scene = card_ui_suit_packed_scenes[index].packed_scene
	
	var card_ui : CardUI = card_ui_packed_scene.instantiate() as CardUI
	card_ui.card = card
	
	add_child(card_ui)
	
	held_card = card_ui
