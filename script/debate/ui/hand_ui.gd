extends VBoxContainer

class_name HandUI

@export_group("Prefab")
@export var top_card_ui_prefab : PackedScene

@export_group("Card Placement")
@export var draw_pile : Control
@export var card_parent : Control

var locked : bool = false

func update_hand(hand : Array[Top]):
	var current_tops = card_parent.get_children().map(func(x): return x.top)
	var new_cards = Util.array_difference(hand, current_tops)
	
	var add_funcs : Array[Callable]
	for top in new_cards:
		add_funcs.append(func() :await add_card(top))
	
	await Util.await_all(add_funcs)
	set_up_focus_connections()
	
	current_tops[0].grab_focus()

func set_up_focus_connections():
	var ui_cards = card_parent.get_children()
	
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
	for child in card_parent.get_children():
		child.queue_free()

func add_card(top : Top):
	var top_card : TopCard = top_card_ui_prefab.instantiate() as TopCard
	top_card.top = top
	
	card_parent.add_child(top_card)

func remove_card(top : Top):
	var ui_top_cards = card_parent.get_children()
	
	var matching = ui_top_cards.filter(func (top_card): return top == top_card.top)
	var top_card = matching[0] if not matching.is_empty() else null
	top_card.queue_free()
