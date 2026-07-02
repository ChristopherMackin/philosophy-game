@tool
extends Rule

class_name ConceptRule

@export var concept : Const.Concept:
	set(val):
		concept = val
		resource_name = Const.Concept.keys()[concept]
		_update_rule_in_editor(resource_name)

func check(query: Dictionary):
	if ! query.has("concept"): return false
	return query["concept"] == concept
