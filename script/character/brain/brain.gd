extends Resource

class_name Brain

var contestant : Contestant
var active_request : SelectionRequest

func select(_request : SelectionRequest) -> SelectionResponse:
	return SelectionResponse.new()

func view(_options : Array, _what : String, _type : String):
	pass

func check_validity(request : SelectionRequest, response : SelectionResponse) -> bool:
	if !active_request:
		return false
	
	var is_valid_selection = true
	
	if response.data is Array:
		for option in response.data:
			if request.options.find(option) == -1:
				is_valid_selection = false
				break
	else:
		if request.options.find(response.data) == -1:
			is_valid_selection = false
	
	return is_valid_selection
