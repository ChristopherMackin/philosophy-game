extends Brain

class_name SimpleAiBrain

func select(request : SelectionRequest) -> SelectionResponse:
	return SelectionResponse.new(
		request.options[randi() % request.options.size()]
	)
