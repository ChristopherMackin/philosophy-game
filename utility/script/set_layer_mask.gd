@tool
extends Node
class_name LayerMask

@onready var parent = $".."
const ARRAY_SIZE : int = 20

@export var layers : Array[bool]:
	set(val):
		layers = val
		update_layers.call_deferred(layers)

func update_layers(layers):
	if (layers.size() < ARRAY_SIZE):
		var difference = ARRAY_SIZE - layers.size()
		layers.resize(ARRAY_SIZE)
		
		for i in difference:
			layers[i] = false
	else:
		layers.resize(ARRAY_SIZE)
	
	for child in Util.get_all_children(parent):
		if child.has_method("set_layer_mask_value"):
			for i in 20:
				child.set_layer_mask_value(i + 1, layers[i])

func set_layer(index, val):
	if index > layers.size() or index <= 0: return
	layers[index - 1] = val
	update_layers(layers)
