@tool
extends Node

class_name EventTreeGraphEditor

signal confirmation_completed(val : bool)

@onready var event_graph = $GraphContainer/EventGraph
@onready var save_dialogue = $SaveDialogue
@onready var confirmation_dialog = $ConfirmationDialog
@onready var path_label = $GraphContainer/MenuBarMarginContainer/MenuBar/PathMarginContainer/PathLabel


var dirty : bool:
	set(val):
		dirty = val
		set_path_label()

var resource_path : String:
	set(val):
		resource_path = val
		set_path_label()
		
var selected_resource : Event

func new_event_tree():
	if(dirty && !await confirm()):
		return
	
	resource_path = ""
	selected_resource = Event.new()
	event_graph.load_event_tree(selected_resource)

func save_event_tree(path : String = ""):
	if path:
		if !ResourceLoader.exists(path):
			var event = Event.new()
			ResourceSaver.save(event, path)
		
		if !load_event_at_path(path):
			return
		
		var event : Event = event_graph.update_event_from_graph(selected_resource)
		ResourceSaver.save(event, resource_path)
		load_event_at_path(resource_path)
		dirty = false
	elif resource_path:
		var event : Event = event_graph.update_event_from_graph(selected_resource)
		ResourceSaver.save(event, resource_path)
		dirty = false
	else:
		save_dialogue.open()

func open_event_tree(path : String):
	if(dirty && !await confirm()):
		return
	
	if load_event_at_path(path):
		event_graph.load_event_tree(selected_resource)
	else:
		push_error("File \"%s\" does not exist or is not an event tree. Please select an event tree resource.")

func load_event_at_path(path : String) -> bool:
	if !ResourceLoader.exists(path):
		return false
	
	var resource = ResourceLoader.load(path)
	
	if !resource is Event:
		return false
	
	resource_path = path
	selected_resource = resource
	return true

func set_dirty_on_input(event : InputEvent):
	if event is InputEventMouseMotion:
		return
	dirty = true

func confirm() -> bool:
	confirmation_dialog.visible = true
	var confirmed = await confirmation_completed
	if confirmed:
		dirty = false
	return confirmed

func confirmation_canceled():
	confirmation_completed.emit(false)

func confirmation_confirmed():
	confirmation_completed.emit(true)

func set_path_label():
	path_label.text = "%s%s" % ["*" if dirty else "", resource_path]

