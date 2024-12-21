extends Node

class_name HandUI

@export_group("Prefab")
@export var top_card_ui_prefab : PackedScene

@export_group("Card Placement")
@export var draw_pile : Control
@export var card_parent : Control

var ui_cards : Array[TopCard]

var locked : bool = false

func update_hand(hand : Array[Top]):
	var current_tops = ui_cards.map(func(x): return x.top)
	var new_cards = Util.array_difference(hand, current_tops)
	
	var add_funcs : Array[Callable]
	for top in new_cards:
		add_funcs.append(func() :await add_card(top))
	
	await Util.await_all(add_funcs)
	set_up_focus_connections()
	
	current_tops[0].grab_focus()

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
	for child in ui_cards:
		child.queue_free()
	ui_cards.clear()

func add_card(top : Top):
	var top_card : TopCard = top_card_ui_prefab.instantiate() as TopCard
	top_card.top = top
	
	card_parent.add_child(top_card)
	ui_cards.append(top_card)

func remove_card(top : Top):	
	var matching = ui_cards.filter(func (top_card): return top == top_card.top)
	var top_card = matching[0] if not matching.is_empty() else null
	var card_index = ui_cards.find(top_card)
	
	if card_index <0:
		return
	
	ui_cards[card_index].queue_free()
	ui_cards.remove_at(card_index)
