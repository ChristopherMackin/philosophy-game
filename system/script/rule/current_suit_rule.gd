@tool
extends Rule

class_name CurrentSuitRule

@export var suit : Suit:
	set(val):
		suit = val
		if suit == null: return
		_update_rule_in_editor(suit.name)

func check(query: Dictionary):
	if ! query.has("current_suit"): return false
	return query["current_suit"] == suit
