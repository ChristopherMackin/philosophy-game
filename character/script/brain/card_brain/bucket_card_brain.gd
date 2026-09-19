extends CardBrain

class_name BucketCardBrain

@export var brains: Array[CardBrain]

func select(request : SelectionRequest) -> SelectionResponse:
	for brain in brains:
		var selection = brain.select(request)
		if selection:
			return selection
	
	return SelectionResponse.new(request.options[0])
