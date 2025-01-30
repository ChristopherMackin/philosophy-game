extends Control

class_name TopsCardSelector

@export var tops_card_ui_pose_packed_scenes : Array[PosePackedScene]
@export var card_container : Container
@export var card_slot_size : Vector2 = Vector2(370, 320)
@export var focus_group : FocusGroup

var ui_cards : Array[TopsCardUI]
var card_slots : Array[Control]

func _ready():
	_clear_card_container()

func _clear_card_container():
	for child in card_container.get_children():
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
	card_container.add_child(tops_card_slot)
	
	card_slots.append(tops_card_slot)
	ui_cards.append(tops_card)

func open_selector(top_array : Array[Top], visible_to_player : bool):
	for top in top_array:
		_add_card(top)
	focus_group.focus(ui_cards[0])
	visible = true

func close_selector():
	visible = false
	_clear_card_container()
