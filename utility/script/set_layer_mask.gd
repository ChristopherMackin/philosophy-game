@tool
extends Node
class_name LayerMask

@onready var parent = $"..":
	set(val):
		if parent != null and parent.is_connected("child_order_changed", _update_layers):
			parent.disconnect("child_order_changed", _update_layers)
		
		parent = val
		
		if parent != null and !parent.is_connected("child_order_changed", _update_layers):
			parent.connect("child_order_changed", _update_layers)
		

@export_flags_3d_render var layers: int:
	set(val):
		layers = val
		_update_layers.call_deferred(layers)

func _update_layers(val):
	for child in Util.get_all_children(parent):
			if "layers" in child and child != self:
				child.layers = val
	

func set_layer(layer: int, value: bool):
	var flag = 1 << layer
	
	if value:
		layers |= flag
	else:
		layers &= ~flag
