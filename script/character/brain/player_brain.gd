extends Brain

class_name PlayerBrain

signal on_selection_requested(request : SelectionRequest)
signal on_selection_made(response : SelectionResponse)

func select(request : SelectionRequest) -> SelectionResponse:
	active_request = request
	
	on_selection_requested.emit(request)
	var response = await on_selection_made
	
	active_request = null
	return response

func make_selection(response: SelectionResponse) -> bool:
	var valid = check_validity(active_request, response)
	
	if valid:
		on_selection_made.emit(response)
	
	return valid
