extends CardBrain

class_name BucketCardBrain

@export var brains: Array[CardBrain]

func select(contestant: Contestant, request : SelectionRequest) -> SelectionResponse:
	if contestant == contestant.manager.computer:
		#TODO: Currently this stops computer from using the hold. 
		#I don't think this is a bad options, but this will have 
		#to be changed if allowing computer hold card is needed.
		request.options = contestant.playable_cards
	
	for brain in brains:
		var selection = brain.select(contestant, request)
		if selection:
			return selection
	
	return SelectionResponse.new(request.options[0])
