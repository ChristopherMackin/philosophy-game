extends Brain

class_name InOrderBrain

func select(request : SelectionRequest) -> SelectionResponse:
	return SelectionResponse.new(
		request.options[0]
	)
