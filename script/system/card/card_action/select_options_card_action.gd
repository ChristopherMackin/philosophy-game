extends CardAction

class_name SelectOptionsCardAction

@export var selection_action : Const.SelectionAction
@export var key : String = "selection"

func invoke(card : Card, player : Contestant, manager : DebateManager):	
	var options = manager.blackboard.get_value("action.options")
	var selection_type := manager.blackboard.get_value("action.type") as Const.SelectionType
	
	if options.size() <= 0: return
	
	var selected_options = []
	
	if selection_action == Const.SelectionAction.SINGLE && options.size() == 1:
		selected_options = options
	
	else:
		var response = await player.select(SelectionRequest.new(
			options,
			selection_action,
			selection_type
		))
		
		match selection_action:
			Const.SelectionAction.SINGLE:
				selected_options = [response.data]
			Const.SelectionAction.MULTI:
				selected_options = response.data
	
	manager.blackboard.add("action.%s" % key, selected_options, Const.ExpirationToken.ON_ACTION_END)	
	
	return true
