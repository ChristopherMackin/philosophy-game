extends Object

class_name ControlHelper

static func get_value(control : Control):
	if control is TextEdit:
		return control.text
	if control is SpinBox:
		return control.value
	if control is CheckButton:
		return control.button_pressed
	if control is CustomResourceLoader:
		return control.path
	if control is OptionButton:
		return control.get_item_id(control.selected)

static func set_value(control : Control, value = null):
	if !value:
		return
	
	if control is TextEdit:
		control.text = value 
	if control is SpinBox:
		control.value = value
	if control is CheckButton: 
		control.button_pressed = value
	if control is CustomResourceLoader:
		control.path = value
	if control is OptionButton:
		control.select(control.get_item_index(value))
