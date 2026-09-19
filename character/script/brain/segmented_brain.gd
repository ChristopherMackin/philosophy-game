class_name SegmentedBrain
extends Brain

@export var play_card_brain: Brain
@export var select_card_brain: Brain
@export var select_token_brain: Brain
@export var select_suit_brain: Brain
@export var default_brain: Brain

func select(request: SelectionRequest) -> SelectionResponse:
	match request.type:
		Const.SelectionType.CARD:
			if request.action == Const.SelectionAction.PLAY:
				return await play_card_brain.request_selection(request)
			else: return await select_card_brain.request_selection(request)
		Const.SelectionType.TOKEN:
			return await select_token_brain.request_selection(request)
		Const.SelectionType.SUIT:
			return await select_suit_brain.request_selection(request)
		_:
			return await default_brain.request_selection(request)
