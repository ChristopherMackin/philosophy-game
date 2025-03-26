extends CardAction

class_name SelectRandomOptionsCardAction

@export var amount : int = 1
@export var key : String = "selection"

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var options : Array = manager.blackboard.get_value("action.options")
	
	if options.size() <= 0: return
	
	var selection = []
	
	var amount = self.amount if self.amount <= options.size() else options.size()
	
	for i in amount:
		selection.append(options[randi() % options.size()])
	
	var selection_index = manager.blackboard.get_value("action.selection_index")
	if selection_index == null: selection_index = 0
	
	manager.blackboard.add("action." % key, selection, Const.ExpirationToken.ON_ACTION_END)
	
	return true
