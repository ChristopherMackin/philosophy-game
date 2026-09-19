@abstract
class_name TokenBrain

extends Brain

func request_selection(contestant: Contestant, request : SelectionRequest) -> SelectionResponse:
	if request.type != Const.SelectionType.TOKEN:
		return null
	
	else: return await super.request_selection(contestant, request)
