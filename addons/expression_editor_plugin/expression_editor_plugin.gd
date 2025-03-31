# my_inspector_plugin.gd
extends EditorInspectorPlugin

var expression_editor = preload("res://addons/expression_editor_plugin/expression_editor.gd")

func _can_handle(object):
	# We support all objects in this example.
	return true


func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	# We handle properties of type integer.
	if hint_type == PROPERTY_HINT_EXPRESSION:
		# Create an instance of the custom property editor and register
		# it to a specific property path.
		add_property_editor(name, expression_editor.new())
		# Inform the editor to remove the default property editor for
		# this property type.
		return true
	else:
		return false
