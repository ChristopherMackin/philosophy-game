@tool
extends Node

class_name EventTreeGraphEditor

@onready var path_label = $VBoxContainer/ColorRect/PathLabel

var resource_path : String:
	get: 
		return resource_path
	set(value):
		resource_path = value
		path_label.text = resource_path

var selected_resource : EventTree:
	get:
		return selected_resource
	set(value):
		if resource_path != null:
			var tree : EventTree = event_graph.get_event_tree()
			ResourceSaver.save(tree, resource_path)
		
		selected_resource = value
		
		if selected_resource != null:
			event_graph.load_event_tree(selected_resource)
			event_graph.visible = true
		else:
			event_graph.visible = false

@onready var event_graph = $EventGraph

func _on_event_tree_picker_file_selected(path):
	var resource = ResourceLoader.load(path)
	
	if resource is EventTree:
		resource_path = path
		selected_resource = resource
	else:
		resource_path = ""
		selected_resource = null
