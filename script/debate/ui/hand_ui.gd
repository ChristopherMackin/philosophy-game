extends Node

class_name HandUI

@export_group("Packed Scene")
@export var card_ui_suit_packed_scenes : Array[SuitPackedScene]

@export_group("Card Placement")
@export var draw_pile : Control
@export var card_parent : Control

@export_group("Card Slot Size")
@export var card_slot_size : Vector2 = Vector2(370, 320)

@export var focus_group : FocusGroup

var ui_cards : Array[CardUI]
var card_slots : Array[Control]

var lock : Lock = Lock.new()

func _ready():
	for child in card_parent.get_children():
		child.queue_free()
	
	card_parent.connect("sort_children", set_up_focus_connections)

func update_hand(hand : Array[Card]):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	var current_tokens = ui_cards.map(func(x): return x.card)
	var new_cards = Util.array_difference(hand, current_tokens)
	var removed_cards = Util.array_difference(current_tokens, hand)
	
	var add_funcs : Array[Callable] = []
	for card in new_cards:
		add_funcs.append(func() :await _add_card(card))
	
	await Util.await_all(add_funcs)
	
	var remove_funcs : Array[Callable] = []
	for card in removed_cards:
		remove_funcs.append(func() :await _remove_card(card))
	
	await Util.await_all(remove_funcs)
	
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
	
	var index = card_ui_suit_packed_scenes.map(func(x): return x.suit).find(card.data.suit)
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
