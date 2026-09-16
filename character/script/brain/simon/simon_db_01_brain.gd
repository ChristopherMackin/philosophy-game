extends Brain

class_name SimonDb01Brain

func select(request : SelectionRequest) -> SelectionResponse:
	
	
	return SelectionResponse.new(
		request.options[0]
	)
