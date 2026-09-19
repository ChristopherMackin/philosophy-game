extends Brain

class_name SimpleAiBrain

func select(contestant: Contestant, request : SelectionRequest) -> SelectionResponse:
	return SelectionResponse.new(
		request.options[randi() % request.options.size()]
	)
