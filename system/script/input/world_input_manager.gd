extends Node

class_name InputManager

@export var active_handler: InputHandler

func _process(delta):
	if active_handler:
		active_handler.handle_input(delta)
