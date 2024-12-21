extends Node

class_name HandUI

@export_group("Prefab")
@export var top_card_ui_prefab : PackedScene

@export_group("Card Placement")
@export var draw_pile : Control
@export var card_parent : Control

@export_group("Card Slot Size")
@export var card_slot_size : Vector2 = Vector2(370, 320)

var ui_cards : Array[TopCard]
var card_slots : Array[Control]

var locked : bool = false

func _ready():
	for child in card_parent.get_children():
		child.queue_free()

func update_hand(hand : Array[Top]):
	var current_tops = ui_cards.map(func(x): return x.top)
	var new_cards = Util.array_difference(hand, current_tops)
	
	var add_funcs : Array[Callable]
	for top in new_cards:
		add_funcs.append(func() :await add_card(top))
	
	await Util.await_all(add_funcs)
	
	set_up_focus_connections()
	
	ui_cards[0].grab_focus()

func set_up_focus_connections():
	for i in ui_cards.size():
		var previous_index = i-1
		var next_index = i+1
		
		ui_cards[i].focus_previous = ui_cards[previous_index].get_path() \
		if previous_index >= 0 && previous_index < ui_cards.size() \
		else ""
		
		ui_cards[i].focus_next = ui_cards[next_index].get_path() \
		if next_index >= 0 && next_index < ui_cards.size() \
		else ""
	
func clear_hand():
	for child in card_slots:
		child.queue_free()
	
	card_slots.clear()
	ui_cards.clear()

func add_card(top : Top):
	var top_card_slot : Control = Control.new()
	top_card_slot.custom_minimum_size = card_slot_size
	
	var top_card : TopCard = top_card_ui_prefab.instantiate() as TopCard
	top_card.top = top
	
	top_card_slot.add_child(top_card)	
	card_parent.add_child(top_card_slot)
	
	card_slots.append(top_card_slot)
	ui_cards.append(top_card)

func remove_card(top : Top):	
	var matching = ui_cards.filter(func (top_card): return top == top_card.top)
	var top_card = matching[0] if not matching.is_empty() else null
	var card_index = ui_cards.find(top_card)
	
	if card_index <0:
		return
	
	card_slots[card_index].queue_free()
	card_slots.remove_at(card_index)
	ui_cards.remove_at(card_index)
