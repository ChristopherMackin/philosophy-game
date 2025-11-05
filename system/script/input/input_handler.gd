extends Resource

class_name InputHandler

signal on_handle_input(delta, input)
signal on_handler_selected
signal on_handler_deselected

func handle_input(delta):
	on_handle_input.emit(delta, Input)
