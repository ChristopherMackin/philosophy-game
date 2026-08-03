@tool
extends Node

class_name EventTreeGraphEditor

signal confirmation_completed(val : bool)

@onready var event_graph = $GraphContainer/EventGraph
@onready var editor_resource_picker = $GraphContainer/MenuBarMarginContainer/EditorResourcePicker
@onready var event_tree_graph_editor = $"."
@onready var event_node_list = $EventNodeList

var selected_resource : Event:
	get:
		return editor_resource_picker.edited_resource
	set(val):
		editor_resource_picker.edited_resource = val

func open_event_tree(resource: Resource):	
	if !resource is Event && resource != null:
		push_error("File \"%s\" does not exist or is not an event tree. Please select an event tree resource.")
		return
	
	if resource == null:
		event_graph.clear_graph()
		event_graph.visible = false
		event_node_list = false
		return
	
	event_graph.visible = true
	event_node_list = true
	
	event_graph.load_event_tree(selected_resource)

func refresh_resource():
	selected_resource = event_graph.update_event_from_graph(selected_resource)
