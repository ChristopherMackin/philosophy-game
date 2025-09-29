extends Resource

class_name InputHandler

signal on_handle_input(delta, input)

func handle_input(delta):
	on_handle_input.emit(delta, Input)
