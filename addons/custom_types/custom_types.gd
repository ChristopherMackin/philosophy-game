# plugin.gd (Inside your addon folder)
@tool
extends EditorPlugin

func _enter_tree() -> void:
	# Arguments: (Custom Type Name, Base Godot Node Type, Concrete Script, Icon)
	add_custom_type(
		"InteractableArea3D", 
		"Area3D", 
		preload("res://system/script/event/interactable.gd"),
		EditorInterface.get_editor_theme().get_icon("Area3D", "EditorIcons")
	)

func _exit_tree() -> void:
	remove_custom_type("GoblinEnemyNode")
