extends Resource

class_name FocusGroup

signal on_focus_changed(focused_node : Node)
signal on_group_selected
signal on_group_deselected

var focused_node : Node

func focus(node : Node):
	if focused_node == node: return
	
	focused_node = node
	on_focus_changed.emit(focused_node)
