@tool
extends Resource

class_name MultiRule

@export var rules : Array[Rule] = []

func check(query : Dictionary) -> bool:
	for rule in rules:
		if !rule.check(query):
			return false
	
	return true
