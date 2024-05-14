@tool
extends EditorPlugin

const addon = preload("res://addons/event_tree_plugin/event_tree_graph_editor.tscn")

var docked_scene

func _enter_tree():
	print("DOCKED")
	docked_scene = addon.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, docked_scene)

func _exit_tree():
	remove_inspector_plugin(docked_scene)
	docked_scene.free()
