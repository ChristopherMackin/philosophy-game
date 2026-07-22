@tool
extends Rule

class_name CurrentTurnRule

@export var current_turn: int = 0

func check(query : Dictionary) -> bool:
	if !query.has("current_turn"): return false
	
	return query["current_turn"] == current_turn
