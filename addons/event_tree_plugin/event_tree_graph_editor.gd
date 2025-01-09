@tool
extends Node

class_name EventTreeGraphEditor

@onready var path_label = $HSplitContainer/NodeSelector/ColorRect/MarginContainer/VBoxContainer/PathLabel
@onready var event_graph = $HSplitContainer/EventGraph
@onready var save_dialogue = $SaveDialogue

var resource_path : String:
	set(val):
		resource_path = val
		path_label.text = resource_path
		
var selected_resource : Event

func create_event_tree(path : String):
	if path == null:
		return
	
	var event = Event.new()
	ResourceSaver.save(event, path)

func create_and_open_event_tree(path : String):
	create_event_tree(path)
	open_event_tree(path)

func save_event_tree(path : String = ""):
	if path:
		if !ResourceLoader.exists(path):
			create_event_tree(path)
		
		if !load_event_at_path(path):
			return
		
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
	
	if load_event_at_path(path):
		event_graph.load_event_tree(selected_resource)
		event_graph.visible = true
	else:
		event_graph.visible = false

func load_event_at_path(path : String) -> bool:
	if !ResourceLoader.exists(path):
		return false
	
	var resource = ResourceLoader.load(path)
	
	if !resource is Event:
		return false
	
	resource_path = path
	selected_resource = resource
	return true
