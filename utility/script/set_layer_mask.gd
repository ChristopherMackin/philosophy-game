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
	for child in parent.get_children():
		if child != self && not child is LayerMask:
			_update_layers_recursive(child)
	
	if "layers" in parent:
		parent.layers = layers

func _update_layers_recursive(node: Node):
	var children = node.get_children()
	
	if children.any(func(x): return x is LayerMask): return
		
	for child in children:
		_update_layers_recursive(child)
	
	if "layers" in node:
		node.layers = layers

func set_layer(layer: int, value: bool):
	var flag = 1 << layer
	
	if value:
		layers |= flag
	else:
		layers &= ~flag
