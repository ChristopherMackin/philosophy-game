@tool
extends VBoxContainer

@onready var graph_node = $".."

@export var resource_picker: EditorResourcePicker:
	set(val):
		if resource_picker and resource_picker.resource_changed.is_connected(update_resource_editor):
			resource_picker.resource_changed.disconnect(update_resource_editor)
		
		resource_picker = val
		
		if resource_picker and !resource_picker.resource_changed.is_connected(update_resource_editor):
			resource_picker.resource_changed.connect(update_resource_editor)

func update_resource_editor(resource: Resource):
	for child in get_children():
		child.visible = false
		child.queue_free()
	
	if resource == null:
		visible = false
		update_node_height()
		return
	
	visible = true
	
	for prop in resource.get_property_list():
		var flags = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_SCRIPT_VARIABLE
		if prop["usage"] & flags == flags and not prop["name"].begins_with("resource_"):
			var control: Control 
			
			control = ControlHelper.instantiate_control_from_variant_type(
				prop,
				func(this_control: Control):
					print(prop["name"])
					if !resource: return
					print(this_control == null)
					resource.set(prop["name"], ControlHelper.get_value(this_control))
					ResourceSaver.save(resource)
			)
			if control: add_child(control)
	
	(func(): update_node_height()).call_deferred()

func update_node_height():
	# Reset size flags/minimum height to let children dictate size
	graph_node.custom_minimum_size.y = 0
	graph_node.size.y = 0
	# Defer the adjustment so Godot finishes calculating the new child layout
	(func(): graph_node.size.y = get_combined_minimum_size().y).call_deferred()
