@tool
extends Rule

class_name CurrentRoundRule

@export var current_round: int = 0

func check(query : Dictionary) -> bool:
	if !query.has("current_round"): return false
	
	return query["current_round"] == current_round
