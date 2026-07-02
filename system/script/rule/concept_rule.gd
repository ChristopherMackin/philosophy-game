@tool
extends Rule

class_name ConceptRule

@export var concept : Const.Concept:
	set(val):
		concept = val
		_update_rule_in_editor(Const.Concept.keys()[concept])

func check(query: Dictionary):
	if ! query.has("concept"): return false
	return query["concept"] == concept
