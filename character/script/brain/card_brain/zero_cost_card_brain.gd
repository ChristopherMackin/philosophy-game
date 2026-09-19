extends CardBrain

class_name ZeroCostCardBrain

func select(request : SelectionRequest) -> SelectionResponse:
	var options = request.options.filter(func(x: Card): return x.cost == 0)
	
	if options.size() <= 0: return null
	else: return options[0]
