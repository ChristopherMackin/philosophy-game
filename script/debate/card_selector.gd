extends Control

class_name CardSelector

@export var card_ui_suit_packed_scenes : Array[SuitPackedScene]
@export var card_container : Container
@export var card_slot_size : Vector2 = Vector2(370, 320)
@export var focus_group : FocusGroup

var ui_cards : Array[CardUI]
var card_slots : Array[Control]

func _ready():
	_clear_card_container()

func _clear_card_container():
	for child in card_container.get_children():
		child.queue_free()
	
	card_slots.clear()
	ui_cards.clear()

func _add_card(card : Card):
	var card_slot : Control = Control.new()
	card_slot.custom_minimum_size = card_slot_size
	
	var index = card_ui_suit_packed_scenes.map(func(x): return x.suit).find(card.data.suit)
	index = index if index >= 0 else 0
	var card_ui_packed_scene = card_ui_suit_packed_scenes[index].packed_scene
	
	var card_ui : CardUI = card_ui_packed_scene.instantiate() as CardUI
	card_ui.card = card
	
	card_slot.add_child(card_ui)	
	card_container.add_child(card_slot)
	
	ui_cards.append(card_ui)
	card_slots.append(card_slot)

func open_selector(card_array : Array[Card], visible_to_player : bool):
	for card in card_array:
		_add_card(card)
	focus_group.focus(ui_cards[0])
	visible = true

func close_selector():
	visible = false
	_clear_card_container()
