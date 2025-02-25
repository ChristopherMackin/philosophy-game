extends Brain

class_name PlayerBrain

signal on_selection_requested(request : SelectionRequest)
signal on_selection_made(response : SelectionResponse)

signal on_view(options : Array, what : String, type : String)
signal on_view_finished()

func select(request : SelectionRequest) -> SelectionResponse:
	on_selection_requested.emit(request)
	var output : SelectionResponse = await on_selection_made
	return output

func view(options : Array, what : String, type : String):
	on_view.emit(options, what, type)
	await on_view_finished

func finish_viewing():
	on_view_finished.emit()

func make_selection(response: SelectionResponse):
	on_selection_made.emit(response)
