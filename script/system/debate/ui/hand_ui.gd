extends VBoxContainer

class_name HandUI

@export var top_card_ui_prefab : PackedScene
@export var card_parent : Control

@export var ordered_card_targets : Array[Control]
@export var reorder_duration : float = .2

var hand : Array[TopCard]

func update_hand(hand : Array[Top]):
	clear()
	
	for top in hand:
		add_card(top)
	
	await GlobalTimer.wait_for_seconds(1)

func clear():
	for top_card in hand:
		top_card.queue_free()
	hand.clear()

func add_card(top : Top):
	if hand.size() >= ordered_card_targets.size():
		return
	
	var top_card : TopCard = top_card_ui_prefab.instantiate() as TopCard
	top_card.top = top
	
	card_parent.add_child(top_card)
	top_card.global_position = ordered_card_targets[hand.size()].global_position
	hand.append(top_card)

func remove_card(top : Top):
	var matching = hand.filter(func (top_card): return top == top_card.top)
	var top_card = matching[0] if not matching.is_empty() else null
	var index = hand.find(top_card)
	
	if index < 0:
		return
		
	hand[index].queue_free() #make some kind of effect for the card being removed here
	hand.remove_at(index)
	
	var tween = get_tree().create_tween().set_parallel()
	
	for i in range(index, hand.size()):
		tween.tween_property(hand[i], "global_position", ordered_card_targets[i].global_position, reorder_duration) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
