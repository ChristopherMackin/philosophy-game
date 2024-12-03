extends Node

@export var ui_clear_focus_node : Control
@export var player_brain : PlayerBrain

func _ready():
	#ui_clear_focus.grab_focus()
	get_viewport().gui_focus_changed.connect(_on_focus_changed)

func _on_focus_changed(control : Control):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("select"):
		var focused_node = get_viewport().gui_get_focus_owner()
		if focused_node != null:
			player_brain.play_top(focused_node.top)
