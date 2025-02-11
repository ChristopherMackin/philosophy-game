extends Brain

class_name PlayerBrain

signal on_input_requested(options : Array, what : String, visible_to_player : bool)
signal on_user_input(option)

func select(options : Array, what : String, visible_to_player : bool = true):
	on_input_requested.emit(options, what, visible_to_player)
	var output = await on_user_input
	return output

func make_selection(option):
	on_user_input.emit(option)
