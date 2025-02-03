extends Node

class_name HandUI

@export_group("Packed Scene")
@export var tops_card_ui_pose_packed_scenes : Array[PosePackedScene]

@export_group("Card Placement")
@export var draw_pile : Control
@export var card_parent : Control

@export_group("Card Slot Size")
@export var card_slot_size : Vector2 = Vector2(370, 320)

@export var focus_group : FocusGroup

var ui_cards : Array[TopsCardUI]
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
	Util.set_up_focus_connections(ui_cards as Array[Control])
	
	if focus_group.focused_node == null && ui_cards.size() > 0:
		focus_group.focus(ui_cards[0])

func clear_hand():
	for child in card_slots:
		child.queue_free()
	
	card_slots.clear()
	ui_cards.clear()

func _add_card(top : Top):
	var tops_card_slot : Control = Control.new()
	tops_card_slot.custom_minimum_size = card_slot_size
	
	var index = tops_card_ui_pose_packed_scenes.map(func(x): return x.pose).find(top.data.pose)
	index = index if index >= 0 else 0
	var tops_card_ui_packed_scene = tops_card_ui_pose_packed_scenes[index].packed_scene
	
	var tops_card : TopsCardUI = tops_card_ui_packed_scene.instantiate() as TopsCardUI
	tops_card.top = top
	
	tops_card_slot.add_child(tops_card)	
	card_parent.add_child(tops_card_slot)
	
	card_slots.append(tops_card_slot)
	ui_cards.append(tops_card)

func _remove_card(top : Top):	
	var matching = ui_cards.filter(func (tops_card): return top == tops_card.top)
	var tops_card = matching[0] if not matching.is_empty() else null
	var card_index = ui_cards.find(tops_card)
	
	if card_index <0:
		return
	
	var new_focus = null
	if ui_cards[card_index].focus_previous: new_focus = get_node_or_null(ui_cards[card_index].focus_previous)
	elif ui_cards[card_index].focus_next: new_focus = get_node_or_null(ui_cards[card_index].focus_next)
	focus_group.focus(new_focus) 
	
	card_slots[card_index].queue_free()
	card_slots.remove_at(card_index)
	ui_cards.remove_at(card_index)
