extends Brain

class_name SimpleAiBrain

func select(selection_request : SelectionRequest):
	return selection_request.options[randi() % selection_request.options.size()]
