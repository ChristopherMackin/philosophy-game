extends Brain

class_name PlayerBrain

signal on_selection_requested(options : Array, what : String, type : String, visible_to_player : bool)
signal on_selection_made(option)

signal on_view(options : Array, what : String, type : String)
signal on_view_finished()

func select(options : Array, what : String, type : String = "card", visible_to_player : bool = true):
	on_selection_requested.emit(options, what, type, visible_to_player)
	var output = await on_selection_made
	return output

func view(options : Array, what : String, type : String):
	on_view.emit(options, type, what)
	await on_view_finished

func finish_viewing():
	on_view_finished.emit()

func make_selection(option):
	on_selection_made.emit(option)
