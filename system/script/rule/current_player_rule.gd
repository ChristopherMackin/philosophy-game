@tool
extends Rule

class_name CurrentPlayerRule

@export var which_contestant: Const.Player

func check(_query : Dictionary) -> bool:
	if !_query.has("active_contestant"): return false
	
	var which_contestant = "player" if which_contestant == Const.Player.HUMAN else "computer"
	return which_contestant == _query["active_contestant"]
