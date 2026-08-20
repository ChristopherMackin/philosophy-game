extends Node

class_name HandUi

@export_group("Card Ui")
@export var card_ui_factory_base: CardUiFactoryBase

@export_group("Card Placement")
@export var draw_pile : Control
@export var card_parent : Control

@export_group("Card Slot Size")
@export var card_slot_size : Vector2 = Vector2(370, 320)

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain
@export var selectable_color: Color = Color.WHITE
@export var not_selectable_color: Color = Color.DARK_GRAY

var cards_ui : Array[CardUi]
var card_slots : Array[Control]

var lock : Lock = Lock.new()

func _ready():
	on_group_deselected()
	
	for child in card_parent.get_children():
		child.queue_free()
	
	card_parent.sort_children.connect(set_up_focus_connections, CONNECT_DEFERRED)
	
	focus_group.on_select.connect(on_select)
	focus_group.on_group_selected.connect(on_group_selected)
	focus_group.on_group_deselected.connect(on_group_deselected)

func on_group_selected():
	self.modulate = selectable_color

func on_group_deselected():
	self.modulate = not_selectable_color

func on_select(data, what: String, _focus_type : String):
	player_brain.make_selection(SelectionResponse.new(data, what))

func update_hand(hand : CardCollection):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	var current_cards = cards_ui.map(func(x): return x.card)
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
	for card_ui in cards_ui:
		if i > 0:
			var previous_path = cards_ui[i-1].get_path()
			card_ui.focus_previous = previous_path
			card_ui.focus_neighbor_left = previous_path
		if i < cards_ui.size() - 1:
			var next_path = cards_ui[i+1].get_path()
			card_ui.focus_next = next_path
			card_ui.focus_neighbor_right = next_path
		i += 1
	
	if focus_group.focused_node == null && cards_ui.size() > 0:
		focus_group.focus(cards_ui[0])

func clear_hand():
	for child in card_slots:
		child.queue_free()
	
	card_slots.clear()
	cards_ui.clear()

func sort_hand(hand : CardCollection):
	var hand_size = hand.get_cards().size()
	
	var sorted_indexes:= []
	var sorted_slots:= []
	var sorted_cards_ui:= []
	
	sorted_slots.resize(hand_size)
	sorted_cards_ui.resize(hand_size)
	
	for card in hand.get_cards():
		sorted_indexes.append(cards_ui.map(func(x): return x.card).find(card))
	
	for i in sorted_indexes.size():
		sorted_slots[sorted_indexes[i]] = card_slots[i]
		sorted_cards_ui[sorted_indexes[i]] = cards_ui[i]
	
	card_slots.assign(sorted_slots)
	cards_ui.assign(sorted_cards_ui)
	
	for slot in card_slots:
		slot.move_to_front()


func _add_card(card : Card):
	var card_slot : Control = Control.new()
	card_slot.custom_minimum_size = card_slot_size
	
	var card_ui_packed_scene = card_ui_factory_base.get_card_ui(card)
	
	var card_ui : CardUi = card_ui_packed_scene.instantiate() as CardUi
	card_ui.card = card
	
	card_slot.add_child(card_ui)	
	card_parent.add_child(card_slot)
	
	card_slots.append(card_slot)
	cards_ui.append(card_ui)

func _remove_card(card : Card):	
	var matching = cards_ui.filter(func (card_ui): return card == card_ui.card)
	var card_ui = matching[0] if not matching.is_empty() else null
	var card_index = cards_ui.find(card_ui)
	
	if card_index <0:
		return
	
	var new_focus = null
	if cards_ui[card_index].focus_previous: new_focus = get_node_or_null(cards_ui[card_index].focus_previous)
	elif cards_ui[card_index].focus_next: new_focus = get_node_or_null(cards_ui[card_index].focus_next)
	focus_group.focus(new_focus) 
	
	card_slots[card_index].queue_free()
	card_slots.remove_at(card_index)
	cards_ui.remove_at(card_index)

func _update_card(card):
	var matching = cards_ui.filter(func (card_ui): return card == card_ui.card)
	var old_card = matching[0] if not matching.is_empty() else null
	var card_index = cards_ui.find(old_card)
	
	if card_index <0:
		return
	
	var card_ui_packed_scene = card_ui_factory_base.get_card_ui(card)
	
	var card_ui = card_ui_packed_scene.instantiate() as CardUi
	card_ui.card = card
	
	cards_ui[card_index] = card_ui
	
	card_slots[card_index].add_child(card_ui)
	
	if focus_group.focused_node == old_card:
		focus_group.focus(card_ui)
	
	old_card.queue_free()
