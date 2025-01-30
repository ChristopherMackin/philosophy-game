extends Brain

class_name PlayerBrain

signal on_input_requested(top_array : Array[Top], what : String, visible_to_player : bool)
signal on_user_input(top : Top)

func select_top(top_array : Array[Top], what : String, visible_to_player : bool = true) -> Top:
	on_input_requested.emit(top_array, what, visible_to_player)
	var top = await on_user_input
	return top

func play_top(top : Top):
	on_user_input.emit(top)
