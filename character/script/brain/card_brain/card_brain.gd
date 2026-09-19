@abstract
class_name CardBrain

extends Brain

func request_selection(contestant: Contestant, request : SelectionRequest) -> SelectionResponse:
	if request.type != Const.SelectionType.CARD:
		return null
	
	else: return await super.request_selection(contestant, request)
