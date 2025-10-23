extends EditorProperty

# The main control for editing the property.
var property_control = ItemList
var current_value = ""
var updating = false

func _init():
	property_control.custom_minimum_size = Vector2(500, 360)
	property_control.text = current_value
	
	add_child(property_control)
