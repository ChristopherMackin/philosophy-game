@abstract
class_name CardBrain

extends Brain

func request_selection(request : SelectionRequest) -> SelectionResponse:
	if request.type != Const.SelectionType.CARD:
		return null
	
	else: return await super.request_selection(request)
