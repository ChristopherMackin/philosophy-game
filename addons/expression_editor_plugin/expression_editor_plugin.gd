extends EditorInspectorPlugin

var expression_editor = preload("res://addons/expression_editor_plugin/expression_editor.gd")

func _can_handle(object):
	return true


func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if hint_type == PROPERTY_HINT_EXPRESSION:
		add_property_editor(name, expression_editor.new())
		return true
	else:
		return false
