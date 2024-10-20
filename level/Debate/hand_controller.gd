extends VBoxContainer

class_name HandController

@export var top_card_ui_prefab : PackedScene

var hand : Array[TopCard]
@export var ordered_card_targets : Array[Control]

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
	
	ordered_card_targets[hand.size() - 1].add_child(top_card)
	hand.append(top_card)

func remove_card(top : Top):
	var matching = hand.filter(func (top_card): return top == top_card.top)
	var top_card = matching[0] if not matching.is_empty() else null
	var index = hand.find(top_card)
	
	if index >= 0:
		hand[index].queue_free()
		hand.remove_at(index)
