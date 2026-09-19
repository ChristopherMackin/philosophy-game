extends Brain

class_name BucketSuitBrain

@export var brains: Array[Brain]

func select(contestant: Contestant, request : SelectionRequest) -> SelectionResponse:
	for brain in brains:
		var selection = brain.select(contestant, request)
		if selection:
			return selection
	
	return SelectionResponse.new(request.options[0])
