@tool
extends Node

class_name EventTreeGraphEditor

@onready var path_label = $HSplitContainer/NodeSelector/ColorRect/MarginContainer/VBoxContainer/PathLabel
@onready var event_graph = $HSplitContainer/EventGraph
@onready var save_dialogue = $SaveDialogue

var resource_path : String
var selected_resource : Event

func create_event_tree(path : String):
	if path == null:
		return
	
	var event = Event.new()
	ResourceSaver.save(event, path)
	
	open_event_tree(path)

func save_event_tree(path : String = ""):
	if path:
		var event : Event = event_graph.update_event_from_graph(selected_resource)
		ResourceSaver.save(event, resource_path)
		open_event_tree(path)
	elif selected_resource:
		var event : Event = event_graph.update_event_from_graph(selected_resource)
		ResourceSaver.save(event, resource_path)
	else:
		save_dialogue.open()

func open_event_tree(path : String):
	if path == null:
		return
	
	resource_path = path
	path_label.text = resource_path
		
	var resource = ResourceLoader.load(resource_path)
	
	if resource != null:
		selected_resource = resource
		event_graph.load_event_tree(selected_resource)
		event_graph.visible = true
	else:
		event_graph.visible = false

