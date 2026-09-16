@tool
extends Rule

class_name CurrentPlayerRule

@export var which_contestant: Const.Player

func check(_query : Dictionary) -> bool:
	var key = Flag.name(Flag.ACTIVE_CONTESTANT)
	if !_query.has(key): return false
	
	var which_contestant = "player" if which_contestant == Const.Player.HUMAN else "computer"
	return which_contestant == _query[key]
