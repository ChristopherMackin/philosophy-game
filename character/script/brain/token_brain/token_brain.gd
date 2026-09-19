@abstract
class_name TokenBrain

extends Brain

func request_selection(request : SelectionRequest) -> SelectionResponse:
	if request.type != Const.SelectionType.TOKEN:
		return null
	
	else: return await super.request_selection(request)
