extends Node

class_name HandUI

@export_group("Packed Scene")
@export var card_ui_suit_packed_scenes : Array[SuitPackedScene]

@export_group("Card Placement")
@export var draw_pile : Control
@export var card_parent : Control

@export_group("Card Slot Size")
@export var card_slot_size : Vector2 = Vector2(370, 320)

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain

var ui_cards : Array[CardUI]
var card_slots : Array[Control]

var lock : Lock = Lock.new()

func _ready():
	for child in card_parent.get_children():
		child.queue_free()
	
	focus_group.on_select.connect(on_select)

func on_select(data, focus_type : String):
	player_brain.make_selection(data)

func update_hand(hand : Array[Card]):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	var current_cards = ui_cards.map(func(x): return x.card)
	var new_cards = Util.array_difference(hand, current_cards)
	var removed_cards = Util.array_difference(current_cards, hand)
	var remaining_cards = Util.array_difference(current_cards, removed_cards)
	
	var add_funcs : Array[Callable] = []
	for card in new_cards:
		add_funcs.append(func() :await _add_card(card))
	
	await Util.await_all(add_funcs)
	
	var remove_funcs : Array[Callable] = []
	for card in removed_cards:
		remove_funcs.append(func() :await _remove_card(card))
	
	await Util.await_all(remove_funcs)
	
	var update_funcs : Array[Callable] = []
	for card in remaining_cards:
		update_funcs.append(func(): await _update_card(card))
	
	await Util.await_all(update_funcs)
	
	card_parent.queue_sort()
	
	lock.release_lock()

func set_up_focus_connections():
	Util.set_up_focus_connections(ui_cards as Array[Control])
	
	if focus_group.focused_node == null && ui_cards.size() > 0:
		focus_group.focus(ui_cards[0])

func clear_hand():
	for child in card_slots:
		child.queue_free()
	
	card_slots.clear()
	ui_cards.clear()

func _add_card(card : Card):
	var card_slot : Control = Control.new()
	card_slot.custom_minimum_size = card_slot_size
	
	var index = card_ui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
	index = index if index >= 0 else 0
	var card_ui_packed_scene = card_ui_suit_packed_scenes[index].packed_scene
	
	var card_ui : CardUI = card_ui_packed_scene.instantiate() as CardUI
	card_ui.card = card
	
	card_slot.add_child(card_ui)	
	card_parent.add_child(card_slot)
	
	card_slots.append(card_slot)
	ui_cards.append(card_ui)

func _remove_card(card : Card):	
	var matching = ui_cards.filter(func (ui_card): return card == ui_card.card)
	var ui_card = matching[0] if not matching.is_empty() else null
	var card_index = ui_cards.find(ui_card)
	
	if card_index <0:
		return
	
	var new_focus = null
	if ui_cards[card_index].focus_previous: new_focus = get_node_or_null(ui_cards[card_index].focus_previous)
	elif ui_cards[card_index].focus_next: new_focus = get_node_or_null(ui_cards[card_index].focus_next)
	focus_group.focus(new_focus) 
	
	card_slots[card_index].queue_free()
	card_slots.remove_at(card_index)
	ui_cards.remove_at(card_index)

func _update_card(card):
	var matching = ui_cards.filter(func (ui_card): return card == ui_card.card)
	var old_card = matching[0] if not matching.is_empty() else null
	var card_index = ui_cards.find(old_card)
	
	if card_index <0:
		return
	
	var index = card_ui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
	index = index if index >= 0 else 0
	var card_ui_packed_scene = card_ui_suit_packed_scenes[index].packed_scene
	
	var ui_card = card_ui_packed_scene.instantiate() as CardUI
	ui_card.card = card
	
	ui_cards[card_index] = ui_card
	
	card_slots[card_index].add_child(ui_card)
	
	if focus_group.focused_node == old_card:
		focus_group.focus(ui_card)
	
	old_card.queue_free()
