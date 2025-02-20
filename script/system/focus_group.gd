extends Resource

class_name FocusGroup

signal on_select(data : Variant, type : String)
signal on_focus_changed(focused_node : Node)
signal on_group_selected
signal on_group_deselected

var focused_node : Node

func focus(node : Node):
	if focused_node == node: return
	
	focused_node = node
	on_focus_changed.emit(focused_node)

func select():
	var property = null
	var focus_type = "default"
	
	if focused_node.has_meta("focus_property"):
		var property_name = focused_node.get_meta("focus_property")
		if property_name && property_name in focused_node:
			property = focused_node.get(property_name)
	
	if focused_node.has_meta("focus_type"):
		focus_type = focused_node.get_meta("focus_type")
	
	on_select.emit(property, focus_type)
