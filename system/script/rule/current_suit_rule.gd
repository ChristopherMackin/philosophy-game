@tool
extends Rule

class_name CurrentSuitRule

@export var suit : Suit:
	set(val):
		suit = val
		if suit == null: return
		_update_rule_in_editor(suit.name)

func check(query: Dictionary):
	var key = Flag.name(Flag.CURRENT_SUIT)
	if ! query.has(key): return false
	return query[key] == suit
