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

var lock : Lock = Lock.new()

func _ready():
	for child in card_parent.get_children():
		child.queue_free()
	
	card_parent.connect("sort_children", set_up_focus_connections)

func update_hand(hand : Array[Top]):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	var current_tops = ui_cards.map(func(x): return x.top)
	var new_cards = Util.array_difference(hand, current_tops)
	var removed_cards = Util.array_difference(current_tops, hand)
	
	var add_funcs : Array[Callable] = []
	for top in new_cards:
		add_funcs.append(func() :await _add_card(top))
	
	await Util.await_all(add_funcs)
	
	var remove_funcs : Array[Callable] = []
	for top in removed_cards:
		remove_funcs.append(func() :await _remove_card(top))
	
	await Util.await_all(remove_funcs)
	
	lock.release_lock()

func set_up_focus_connections():
	for card in ui_cards:
		card.focus_neighbor_left = NodePath()
		card.focus_neighbor_top = NodePath()
		card.focus_neighbor_bottom = NodePath()
		card.focus_neighbor_right = NodePath()
		
		var other_cards = Util.array_difference(ui_cards, [card])
		other_cards.sort_custom(func (a, b): return card.global_position.distance_to(a.global_position) < card.global_position.distance_to(b.global_position)) 
		
		for other in other_cards:
			var direction_vector = (other.global_position - card.global_position).normalized()
			if(abs(direction_vector.x) > abs(direction_vector.y)):
				if(sign(direction_vector.x) >= 0):
					if(card.focus_neighbor_right == NodePath()):
						card.focus_neighbor_right = other.get_path()
				elif(sign(direction_vector.x) <= 0):
					if(card.focus_neighbor_left == NodePath()):
						card.focus_neighbor_left = other.get_path()
			else:
				if(sign(direction_vector.y) <= 0):
					if(card.focus_neighbor_top == NodePath()):
						card.focus_neighbor_top = other.get_path()
				elif(sign(direction_vector.y) >= 0):
					if(card.focus_neighbor_bottom == NodePath()):
						card.focus_neighbor_bottom = other.get_path()
	
	#need to set up previous
	if ui_cards.size() > 0:
		ui_cards[0].grab_focus()

func clear_hand():
	for child in card_slots:
		child.queue_free()
	
	card_slots.clear()
	ui_cards.clear()

func _add_card(top : Top):
	var top_card_slot : Control = Control.new()
	top_card_slot.custom_minimum_size = card_slot_size
	
	var top_card : TopCard = top_card_ui_prefab.instantiate() as TopCard
	top_card.top = top
	
	top_card_slot.add_child(top_card)	
	card_parent.add_child(top_card_slot)
	
	card_slots.append(top_card_slot)
	ui_cards.append(top_card)

func _remove_card(top : Top):	
	var matching = ui_cards.filter(func (top_card): return top == top_card.top)
	var top_card = matching[0] if not matching.is_empty() else null
	var card_index = ui_cards.find(top_card)
	
	if card_index <0:
		return
	
	card_slots[card_index].queue_free()
	card_slots.remove_at(card_index)
	ui_cards.remove_at(card_index)
