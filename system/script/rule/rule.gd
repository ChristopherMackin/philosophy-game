@tool
extends Resource

class_name Rule

func _init():
	resource_name = "RU: " + get_script().get_global_name()

func check(query : Dictionary) -> bool:
	return false

func _update_rule_in_editor(name: String):
	resource_name = "RU: " + name
	on_rule_editor_updated.emit(name)

signal on_rule_editor_updated(name: String)
