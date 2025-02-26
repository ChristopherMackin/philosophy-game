extends Brain

class_name PlayerBrain

signal on_selection_requested(request : SelectionRequest)
signal on_selection_made(response : SelectionResponse)

signal on_view(options : Array, what : String, type : String)
signal on_view_finished()

func select(request : SelectionRequest) -> SelectionResponse:
	active_request = request
	
	on_selection_requested.emit(request)
	var response = await on_selection_made
	
	active_request = null
	return response

func view(options : Array, what : String, type : String):
	on_view.emit(options, what, type)
	await on_view_finished

func finish_viewing():
	on_view_finished.emit()

func make_selection(response: SelectionResponse) -> bool:
	var valid = check_validity(active_request, response)
	
	if valid:
		on_selection_made.emit(response)
	
	return valid
