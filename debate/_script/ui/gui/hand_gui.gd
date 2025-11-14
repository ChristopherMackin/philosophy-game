extends Node

class_name HandGUI

@export_group("Packed Scene")
@export var default_card_gui_packed_scene: PackedScene
@export var default_tokenless_card_gui_packed_scene: PackedScene

@export var card_gui_suit_packed_scenes : Array[SuitPackedScene]
@export var tokenless_card_gui_suit_packed_scenes : Array[SuitPackedScene]

@export_group("Card Placement")
@export var draw_pile : Control
@export var card_parent : Control

@export_group("Card Slot Size")
@export var card_slot_size : Vector2 = Vector2(370, 320)

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain

var cards_gui : Array[CardGUI]
var card_slots : Array[Control]

var lock : Lock = Lock.new()

func _ready():
	for child in card_parent.get_children():
		child.queue_free()
	
	card_parent.sort_children.connect(set_up_focus_connections, CONNECT_DEFERRED)
	
	focus_group.on_select.connect(on_select)

func on_select(data, what: String, focus_type : String):
	player_brain.make_selection(SelectionResponse.new(data, what))

func update_hand(hand : CardCollection):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	var current_cards = cards_gui.map(func(x): return x.card)
	var new_cards = Util.array_difference(hand.get_cards(), current_cards)
	var removed_cards = Util.array_difference(current_cards, hand.get_cards())
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
	
	sort_hand(hand)
	
	card_parent.queue_sort()
	
	lock.release_lock()

func set_up_focus_connections():
	var i: int = 0
	for card_gui in cards_gui:
		if i > 0:
			var previous_path = cards_gui[i-1].get_path()
			card_gui.focus_previous = previous_path
			card_gui.focus_neighbor_left = previous_path
		if i < cards_gui.size() - 1:
			var next_path = cards_gui[i+1].get_path()
			card_gui.focus_next = next_path
			card_gui.focus_neighbor_right = next_path
		i += 1
	
	if focus_group.focused_node == null && cards_gui.size() > 0:
		focus_group.focus(cards_gui[0])

func clear_hand():
	for child in card_slots:
		child.queue_free()
	
	card_slots.clear()
	cards_gui.clear()

func sort_hand(hand : CardCollection):
	var children = card_parent.get_children()
	
	for card in hand.get_cards():
		var index = cards_gui.map(func(x): return x.card).find(card)
		card_slots[index].move_to_front()


func _add_card(card : Card):
	var card_slot : Control = Control.new()
	card_slot.custom_minimum_size = card_slot_size
	
	var card_gui_packed_scene = get_card_gui_packed_scene(card)
	
	var card_gui : CardGUI = card_gui_packed_scene.instantiate() as CardGUI
	card_gui.card = card
	
	card_slot.add_child(card_gui)	
	card_parent.add_child(card_slot)
	
	card_gui.scale = Vector2(.81, .81)
	
	card_slots.append(card_slot)
	cards_gui.append(card_gui)

func _remove_card(card : Card):	
	var matching = cards_gui.filter(func (card_gui): return card == card_gui.card)
	var card_gui = matching[0] if not matching.is_empty() else null
	var card_index = cards_gui.find(card_gui)
	
	if card_index <0:
		return
	
	var new_focus = null
	if cards_gui[card_index].focus_previous: new_focus = get_node_or_null(cards_gui[card_index].focus_previous)
	elif cards_gui[card_index].focus_next: new_focus = get_node_or_null(cards_gui[card_index].focus_next)
	focus_group.focus(new_focus) 
	
	card_slots[card_index].queue_free()
	card_slots.remove_at(card_index)
	cards_gui.remove_at(card_index)

func _update_card(card):
	var matching = cards_gui.filter(func (card_gui): return card == card_gui.card)
	var old_card = matching[0] if not matching.is_empty() else null
	var card_index = cards_gui.find(old_card)
	
	if card_index <0:
		return
	
	var card_gui_packed_scene = get_card_gui_packed_scene(card)
	
	var card_gui = card_gui_packed_scene.instantiate() as CardGUI
	card_gui.card = card
	
	cards_gui[card_index] = card_gui
	
	card_slots[card_index].add_child(card_gui)
	
	card_gui.scale = Vector2(.81, .81)
	
	if focus_group.focused_node == old_card:
		focus_group.focus(card_gui)
	
	old_card.queue_free()

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
