extends Brain

class_name InOrderBrain

func select(contestant: Contestant, request : SelectionRequest) -> SelectionResponse:
	return SelectionResponse.new(
		request.options[0]
	)
