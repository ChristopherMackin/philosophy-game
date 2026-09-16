extends Brain

class_name SimonDb01Brain

func select(request : SelectionRequest) -> SelectionResponse:
	if request.is_card_play_request: return select_card_to_play(request)
	
	return SelectionResponse.new(
		request.options[0]
	)

func select_card_to_play(request: SelectionRequest) -> SelectionResponse:
	var cards_played_this_turn = debate_blackboard.get_flag_value(Flag.CARDS_PLAYED_THIS_TURN)
	
	match cards_played_this_turn:
		0:
			var index = request.options.find_custom(func(c: Card): return c.tags.has(Card.Tag.ALTER) and c.tags.has(Card.Tag.OPPONENT))
			if index != -1: return SelectionResponse.new(request.options[index])
	
	return SelectionResponse.new(
			request.options[0]
		)
