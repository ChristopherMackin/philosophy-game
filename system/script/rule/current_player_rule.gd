@tool
extends Rule

class_name CurrentPlayerRule

@export var which_contestant: Const.Player

func check(_query : Dictionary) -> bool:
	var key = Flag.name(Flag.WHICH_CONTESTANT)
	if !_query.has(key): return false
	
	return Const.Player.values()[which_contestant] == _query[key]
