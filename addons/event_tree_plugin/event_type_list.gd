extends ItemList

@export var event_graph : GraphEdit
@export var event_node_type_parent : Control

func _ready():
	for child in event_node_type_parent.get_children():
		add_item(child.name)

func _on_item_activated(index):
	var node = event_node_type_parent.get_child(index).duplicate()
	event_graph.add_child(node, true) # Use a friendly node 

func _on_empty_clicked(at_position, mouse_button_index):
	deselect_all()
