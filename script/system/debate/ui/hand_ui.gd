extends VBoxContainer

class_name HandUI

@export var top_card_ui_prefab : PackedScene
@export var card_parent : Control

@export var ordered_card_targets : Array[Control]
@export var reorder_speed : float = .2

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
	
	var lerp_funcs : Array[Callable]
	
	for i in range(index, hand.size()):
		lerp_funcs.append(func(): await Util.lerp_to_position(hand[i], ordered_card_targets[i].global_position, reorder_speed))
	
	await Util.await_all(lerp_funcs)
