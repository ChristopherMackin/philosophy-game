extends Brain

class_name PlayerBrain

signal on_selection_requested(selection_request : SelectionRequest)
signal on_selection_made(option)

signal on_view(options : Array, what : String, type : String)
signal on_view_finished()

func select(selection_request : SelectionRequest):
	on_selection_requested.emit(selection_request)
	var output = await on_selection_made
	return output

func view(options : Array, what : String, type : String):
	on_view.emit(options, what, type)
	await on_view_finished

func finish_viewing():
	on_view_finished.emit()

func make_selection(option):
	on_selection_made.emit(option)
