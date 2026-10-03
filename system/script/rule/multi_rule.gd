@tool
extends Rule

class_name MultiRule

@export_enum("AND", "OR") var operation: int = 0
@export var rules : Array[Rule] = []

func check(query : Dictionary) -> bool:
	match operation:
		0: return _and(query)
		1: return _or(query)
	
	return false

func _and(query: Dictionary) -> bool:
	for rule in rules:
		if !rule.check(query):
			return false
	
	return true

func _or(query: Dictionary) -> bool:
	for rule in rules:
		if rule.check(query):
			return true
	
	return false
