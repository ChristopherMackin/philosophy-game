extends Node

class_name SelectionManager

@export var ui_clear_focus_node : Control
@export var player_brain : PlayerBrain
var saved_focus_node : Control
var focused_node : Control:
	get: return get_viewport().gui_get_focus_owner()

func _ready():
	#ui_clear_focus.grab_focus()
	get_viewport().gui_focus_changed.connect(_on_focus_changed)

func _on_focus_changed(control : Control):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("select"):
		if focused_node != null:
			player_brain.play_top(focused_node.top)

func pause_ui_input():
	if focused_node == ui_clear_focus_node:
		return
	
	saved_focus_node = focused_node
	ui_clear_focus_node.grab_focus()

func continue_ui_input():
	if focused_node != ui_clear_focus_node || saved_focus_node == null:
		return
	
	saved_focus_node.grab_focus()
