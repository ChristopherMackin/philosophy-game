@tool
extends Resource

class_name Rule

func check(query : Dictionary) -> bool:
	return false

func _update_rule_in_editor(name: String):
	on_rule_editor_updated.emit(name)

signal on_rule_editor_updated(name: String)
