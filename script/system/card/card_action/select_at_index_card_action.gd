extends CardAction

class_name SelectAtIndexCardAction

@export var index : int = 0
@export var key : String = "selection"

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var options : Array = manager.blackboard.get_value("action.options")
	
	if options.size() <= 0 || index >= options.size(): return
	
	var selection = [options[index]]
	
	manager.blackboard.add("action.%s" % key, selection, Const.ExpirationToken.ON_ACTION_END)
	
	return true
