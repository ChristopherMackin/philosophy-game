@abstract
class_name SuitBrain

extends Brain

func request_selection(contestant: Contestant, request : SelectionRequest) -> SelectionResponse:
	if request.type != Const.SelectionType.SUIT:
		return null
	
	else: return await super.request_selection(contestant, request)
