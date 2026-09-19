extends Brain

class_name BucketTokenBrain

@export var brains: Array[Brain]

func select(request : SelectionRequest) -> SelectionResponse:
	for brain in brains:
		var selection = brain.select(request)
		if selection:
			return selection
	
	return SelectionResponse.new(request.options[0])
