extends VBoxContainer

class_name HandUI

@export_group("Prefab")
@export var top_card_ui_prefab : PackedScene

@export_group("Card Placement")
@export var draw_pile : Control
@export var card_parent : Control
@export var ordered_card_targets : Array[Control]
@export var reorder_duration : float = .2

var locked : bool = false

var ui_top_cards : Array[TopCard] = []

func update_hand(hand : Array[Top]):
	var current_tops = ui_top_cards.map(func(x): return x.top)
	var new_cards = Util.array_difference(hand, current_tops)
	
	var add_funcs : Array[Callable]
	for top in new_cards:
		add_funcs.append(func() :await add_card(top))
	
	await Util.await_all(add_funcs)
	set_up_focus_connections()
	
	ui_top_cards[0].grab_focus()

func set_up_focus_connections():
	for i in ui_top_cards.size():
		var previous_index = i-1
		var next_index = i+1
		
		ui_top_cards[i].focus_previous = ui_top_cards[previous_index].get_path() \
		if previous_index >= 0 && previous_index < ui_top_cards.size() \
		else ""
		
		ui_top_cards[i].focus_next = ui_top_cards[next_index].get_path() \
		if next_index >= 0 && next_index < ui_top_cards.size() \
		else ""
	

func clear_hand():
	for top_card in ui_top_cards:
		top_card.queue_free()
	ui_top_cards.clear()

func add_card(top : Top):
	if ui_top_cards.size() >= ordered_card_targets.size():
		return
	
	var top_card : TopCard = top_card_ui_prefab.instantiate() as TopCard
	top_card.top = top
	
	card_parent.add_child(top_card)
	top_card.global_position = draw_pile.global_position
	ui_top_cards.append(top_card)
	
	var target_pos = ordered_card_targets[ui_top_cards.size() - 1].global_position
	var tween = get_tree().create_tween().tween_property(top_card, "global_position", target_pos, .2)
	await tween.finished

func remove_card(top : Top):
	var matching = ui_top_cards.filter(func (top_card): return top == top_card.top)
	var top_card = matching[0] if not matching.is_empty() else null
	var index = ui_top_cards.find(top_card)
	
	if index < 0:
		return
	
	var new_focus = get_node(ui_top_cards[index].focus_previous) \
	if ui_top_cards[index].focus_previous \
	else ui_top_cards[1]
	
	new_focus.grab_focus()
	
	ui_top_cards[index].queue_free() #make some kind of effect for the card being removed here
	ui_top_cards.remove_at(index)
	
	if range(index, ui_top_cards.size()).size() <= 0:
		return;
	
	var tween = get_tree().create_tween().set_parallel()
	
	for i in range(index, ui_top_cards.size()):
		tween.tween_property(ui_top_cards[i], "global_position", ordered_card_targets[i].global_position, reorder_duration) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
	
	await tween.finished
	
	set_up_focus_connections()
