extends EditorInspectorPlugin

var blackboard = preload("res://addons/blackboard_inspector_plugin/blackboard_inspector.gd")

func _can_handle(object):
	return object is Blackboard

func _parse_begin(object):
	add_property_editor("Blackboard Entries", blackboard.new())

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	return true
