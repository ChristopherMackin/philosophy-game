extends Node

class_name InputManager

@export var active_handler: InputHandler:
	set(val):
		if active_handler != null: active_handler.on_handler_deselected.emit()
		active_handler = val
		if active_handler != null: active_handler.on_handler_selected.emit()


func _process(delta):
	if active_handler:
		active_handler.handle_input(delta)
