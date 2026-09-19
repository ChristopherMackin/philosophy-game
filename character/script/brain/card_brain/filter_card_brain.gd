class_name FilterCardBrain

extends CardBrain

@export var filters: Array[CardArrayFilter]

func select(contestant: Contestant, _request: SelectionRequest) -> SelectionResponse:
	var card_array: Array[Card]
	card_array.assign(_request.options)
	
	print(card_array)
	
	for filter in filters:
		card_array = await filter.filter(card_array, _request.caller, contestant, contestant.manager)
	
	if card_array.size() > 0: return SelectionResponse.new(card_array[0])
	
	return null
