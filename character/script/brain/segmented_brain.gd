class_name SegmentedBrain
extends Brain

@export var play_card_brain: Brain
@export var select_card_brain: Brain
@export var select_token_brain: Brain
@export var select_suit_brain: Brain
@export var default_brain: Brain

func select(contestant: Contestant, request: SelectionRequest) -> SelectionResponse:
	var selection: SelectionResponse
	
	match request.type:
		Const.SelectionType.CARD:
			if request.action == Const.SelectionAction.PLAY:
				selection =  await play_card_brain.request_selection(contestant, request)
			else: selection = await select_card_brain.request_selection(contestant, request)
		Const.SelectionType.TOKEN:
			selection =  await select_token_brain.request_selection(contestant, request)
		Const.SelectionType.SUIT:
			selection = await select_suit_brain.request_selection(contestant, request)
		_:
			selection = await default_brain.request_selection(contestant, request)
	
	if !selection: return SelectionResponse.new(request.options[0])
	
	return selection
