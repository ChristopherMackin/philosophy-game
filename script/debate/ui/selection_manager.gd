extends Node

class_name SelectionManager

@export_group("Player")
@export var player_brain : PlayerBrain

@export_group("Focus Groups")
@export var idle_focus_group : FocusGroup
@export var hand_ui_focus_group : FocusGroup
@export var play_area_selector_focus_group : FocusGroup
@export var tops_card_selector_focus_group : FocusGroup

@export_group("Focus Clear")
@export var ui_clear_focus_node : Control

@export_group("Selectors")
@export var play_area_selector : PlayAreaSelector
@export var tops_card_selector : TopsCardSelector

var active_focus_group : FocusGroup

var focused_node : Control:
	get: return active_focus_group.focused_node

func _ready():
	idle_focus_group.focused_node = ui_clear_focus_node
	player_brain.on_input_requested.connect(on_input_requested)
	get_viewport().gui_focus_changed.connect(on_focus_changed)

func on_focus_changed(node : Node):
	if node is Control:
		node.grab_focus()
	else: ui_clear_focus_node.grab_focus()
	
	active_focus_group.focus(node)

func _unhandled_input(event):
	if event.is_action_pressed("select"):
		if focused_node != null && "top" in focused_node:
			player_brain.play_top(focused_node.top)
			play_area_selector.close_selector()
			tops_card_selector.close_selector()

func on_input_requested(top_array : Array[Top], what : String, visible_to_player : bool):
	if what == "play":
		set_focus_group(hand_ui_focus_group)
	elif what == "board_top_removal":
		play_area_selector.open_selector(top_array)
		set_focus_group(play_area_selector_focus_group)
	else:
		tops_card_selector.open_selector(top_array, visible_to_player)
		set_focus_group(tops_card_selector_focus_group)

func pause_input():
	set_focus_group(idle_focus_group)

func set_focus_group(focus_group : FocusGroup):
	if active_focus_group:
		active_focus_group.on_focus_changed.disconnect(on_focus_changed)
		active_focus_group.on_group_deselected.emit()
	
	active_focus_group = focus_group
	active_focus_group.on_focus_changed.connect(on_focus_changed)
	active_focus_group.on_group_selected.emit()
	
	on_focus_changed(active_focus_group.focused_node)
