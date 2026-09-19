@abstract
class_name Brain
extends Resource

const max_try_count: int = 10
var current_try: int = 0
var active_request : SelectionRequest

func request_selection(contestant: Contestant, request : SelectionRequest) -> SelectionResponse:
	active_request = request
	var selection: SelectionResponse = await select(contestant, request)
	
	while !check_validity(request, selection):
		if current_try >= max_try_count:
			selection = SelectionResponse.new(request.options[0])
			push_error("ERROR: Brain selection loop has failed! Crash to desktop")
			if !check_validity(request, selection): Engine.get_main_loop().quit()
			break
		current_try += 1
		selection = await select(contestant, request)
	
	current_try = 0
	active_request = null
	
	return selection

func select(_contestant: Contestant, _request: SelectionRequest) -> SelectionResponse:
	return SelectionResponse.new()

func check_validity(request : SelectionRequest, response : SelectionResponse) -> bool:
	if !active_request: return false
	
	if active_request.action == Const.SelectionAction.VIEW: return true
	
	var is_valid_selection = true
	
	if response.data is Array:
		for option in response.data:
			if request.options.find(option) == -1:
				is_valid_selection = false
				break
	else:
		if request.options.find(response.data) == -1:
			is_valid_selection = false
	
	return is_valid_selection
