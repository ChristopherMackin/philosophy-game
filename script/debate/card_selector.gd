extends Control

class_name CardSelector

enum CardSelectorMode {
	VIEW,
	SINGLE,
	MULTI
}

@export_group("Packed Scene")
@export var card_ui_suit_packed_scenes : Array[SuitPackedScene]

@export_group("Layout")
@export var card_container : Container
@export var card_slot_size : Vector2 = Vector2(370, 320)

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain
@export var submit_button : Control

var ui_cards : Array[CardUI]
var card_slots : Array[Control]
var selection_array : Array

func _ready():
	_clear_card_container()

func _clear_card_container():
	for child in card_container.get_children():
		child.queue_free()
	
	card_slots.clear()
	ui_cards.clear()
	selection_array.clear()

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

func open_selector(card_array : Array[Card], visible_to_player : bool, mode : CardSelectorMode):
	for card in card_array:
		_add_card(card)
	
	match mode:
		CardSelectorMode.VIEW:
			submit_button.visible = true
			Util.set_up_focus_connections.call_deferred([submit_button])
			
			focus_group.focus(submit_button)
			focus_group.on_select.connect(on_select_view)
		CardSelectorMode.SINGLE:
			submit_button.visible = false
			Util.set_up_focus_connections.call_deferred(ui_cards)
			
			focus_group.focused_node = ui_cards[0]
			focus_group.on_select.connect(on_select_single)
		CardSelectorMode.MULTI:
			submit_button.visible = true
			var focus_items : Array[Control] = []
			focus_items.append_array(ui_cards)
			focus_items.append(submit_button)
			Util.set_up_focus_connections.call_deferred(focus_items)
			
			for ui_card in ui_cards:
				ui_card.modulate = Color.GRAY
			
			focus_group.focused_node = ui_cards[0]
			focus_group.on_select.connect(on_select_multi)
	visible = true

func close_selector():
	visible = false
	_clear_card_container()

func on_select_view(data, focus_type : String):
	player_brain.finish_viewing()
	focus_group.on_select.disconnect(on_select_view)
	close_selector()

func on_select_single(data, focus_type : String):
	player_brain.make_selection(data)
	focus_group.on_select.disconnect(on_select_single)
	close_selector()

func on_select_multi(data, focus_type : String):
	if focus_type == "submit":
		player_brain.make_selection(selection_array)
		focus_group.on_select.disconnect(on_select_multi)
		close_selector()
	else:
		var ui_card_index = ui_cards.map(func(x): return x.card).find(data)
		var ui_card = ui_cards[ui_card_index]
		
		if selection_array.has(data):
			var index = selection_array.find(data)
			selection_array.remove_at(index)
			ui_card.modulate = Color.GRAY
		else:
			selection_array.append(data)
			ui_card.modulate = Color.WHITE
