@tool
extends Node

class_name EventTreeGraphEditor

@onready var path_label = $VBoxContainer/ColorRect/HBoxContainer/PathLabel
@onready var event_graph : EventGraph = $EventGraph

var resource_path : String:
	get: 
		return resource_path
	set(value):
		if resource_path != null:
			var tree : EventTree = event_graph.get_event_tree()
			ResourceSaver.save(tree, resource_path)
		
		resource_path = value
		path_label.text = resource_path
		
		var resource = ResourceLoader.load(resource_path)
		
		if resource != null:
			selected_resource = resource
			event_graph.load_event_tree(selected_resource)
			event_graph.visible = true
		else:
			event_graph.visible = false

var selected_resource : EventTree

func save_event_tree():
	var tree : EventTree = event_graph.get_event_tree()
	
	ResourceSaver.save(tree, resource_path)

func open_event_tree(path):
	if path == null:
		return
		
	resource_path = path
