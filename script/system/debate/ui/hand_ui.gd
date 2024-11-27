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

var hand_3d : Array[TopCard] = []

func update_hand(hand : Array[Top]):
	var current_tops = hand_3d.map(func(x): return x.top)
	var new_cards = Util.array_difference(hand, current_tops)
	
	var add_funcs : Array[Callable]
	for top in new_cards:
		add_funcs.append(func() :await add_card(top))
	
	await Util.await_all(add_funcs)

func clear_hand():
	for top_card in hand_3d:
		top_card.queue_free()
	hand_3d.clear()

func add_card(top : Top):
	if hand_3d.size() >= ordered_card_targets.size():
		return
	
	var top_card : TopCard = top_card_ui_prefab.instantiate() as TopCard
	top_card.top = top
	
	card_parent.add_child(top_card)
	top_card.global_position = draw_pile.global_position
	hand_3d.append(top_card)
	
	var target_pos = ordered_card_targets[hand_3d.size() - 1].global_position
	var tween = get_tree().create_tween().tween_property(top_card, "global_position", target_pos, .2)
	await tween.finished

func remove_card(top : Top):
	var matching = hand_3d.filter(func (top_card): return top == top_card.top)
	var top_card = matching[0] if not matching.is_empty() else null
	var index = hand_3d.find(top_card)
	
	if index < 0:
		return
		
	hand_3d[index].queue_free() #make some kind of effect for the card being removed here
	hand_3d.remove_at(index)
	
	if range(index, hand_3d.size()).size() <= 0:
		return;
	
	var tween = get_tree().create_tween().set_parallel()
	
	for i in range(index, hand_3d.size()):
		tween.tween_property(hand_3d[i], "global_position", ordered_card_targets[i].global_position, reorder_duration) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
	
	await tween.finished
