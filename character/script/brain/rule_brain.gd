extends Brain

class_name RuleBrain

@export var rule: Rule
@export var brain: Brain

func select(request : SelectionRequest) -> SelectionResponse:
	if !rule.check(contestant.manager.blackboard.get_query()): return null
	
	return await brain.request_selection(request)
