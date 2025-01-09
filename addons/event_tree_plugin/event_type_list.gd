@tool
extends ItemList

@export var event_graph : GraphEdit
@export var task_node_type_parent : Control
var index : int = -1


func _enter_tree():
	clear()
	
	for child in task_node_type_parent.get_children():
		add_item(child.name)

func _on_item_activated(index):
	var node = task_node_type_parent.get_child(index).duplicate()
	event_graph.add_child(node, true) # Use a friendly node 
	node.position_offset = (event_graph.scroll_offset + event_graph.size / 2) / event_graph.zoom - node.size / 2;

func _on_empty_clicked(at_position, mouse_button_index):
	deselect_all()
	index = -1

func _get_drag_data(position):
	var task_node = task_node_type_parent.get_child(index)
	set_drag_preview(task_node.duplicate())
	return task_node

func _on_item_selected(index):
	self.index = index
