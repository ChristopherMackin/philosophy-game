extends Resource

class_name FocusGroup

signal on_select(data : Variant, what: String, type : String)
signal on_focus_changed(focused_node : Node)

var is_active_group: bool = false

func on_group_selected():
	is_active_group = true
	var signal_node = get_focus_group_signal_node(focused_node)
	
	if !signal_node: return
	
	signal_node.on_focus_entered.emit()

func on_group_deselected():
	is_active_group = false
	var signal_node = get_focus_group_signal_node(focused_node)
	
	if !signal_node: return
	
	signal_node.on_focus_exited.emit()

var focused_node : Control

func focus(node : Control):
	if focused_node == node: return
	
	if is_active_group:
		var signal_node = get_focus_group_signal_node(focused_node)
		if signal_node: signal_node.on_focus_exited.emit()
	
	focused_node = node
	
	if is_active_group:
		var signal_node = get_focus_group_signal_node(focused_node)
		if signal_node: signal_node.on_focus_entered.emit()
		
	on_focus_changed.emit(focused_node)

func focus_top():
	if focused_node.focus_neighbor_top != NodePath():
		focus(focused_node.get_node(focused_node.focus_neighbor_top))

func focus_bottom():
	if focused_node.focus_neighbor_bottom != NodePath():
		focus(focused_node.get_node(focused_node.focus_neighbor_bottom))
		
func focus_left():
	if focused_node.focus_neighbor_left != NodePath():
		focus(focused_node.get_node(focused_node.focus_neighbor_left))
		
func focus_right():
	if focused_node.focus_neighbor_right != NodePath():
		focus(focused_node.get_node(focused_node.focus_neighbor_right))
		
func focus_next():
	if focused_node.focus_next != NodePath():
		focus(focused_node.get_node(focused_node.focus_next))
		
func focus_previous():
	if focused_node.focus_previous != NodePath():
		focus(focused_node.get_node(focused_node.focus_previous))

func select(what: String = "play"):
	var property = null
	var focus_type = "default"
	
	if focused_node.has_meta("focus_property"):
		var property_name = focused_node.get_meta("focus_property")
		if property_name && property_name in focused_node:
			property = focused_node.get(property_name)
	
	if focused_node.has_meta("focus_type"):
		focus_type = focused_node.get_meta("focus_type")
	
	on_select.emit(property, what, focus_type)

func get_focus_group_signal_node(focused_node: Control):
	if !focused_node: return
	
	return focused_node.find_child("FocusGroupSignalNode")
