@tool
extends EditorPlugin

var plugin

func _enter_tree():
	plugin = preload("res://addons/expression_editor_plugin/expression_editor_plugin.gd").new()
	add_inspector_plugin(plugin)

func _exit_tree():
	remove_inspector_plugin(plugin)
