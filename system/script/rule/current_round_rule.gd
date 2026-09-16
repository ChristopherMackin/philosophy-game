@tool
extends Rule

class_name CurrentRoundRule

@export var current_round: int = 0

func check(query : Dictionary) -> bool:
	var key = Flag.name(Flag.CURRENT_ROUND)
	if !query.has(key): return false
	
	return query[key] == current_round
