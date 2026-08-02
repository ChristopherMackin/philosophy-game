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
	if control is EditorResourcePicker:
		return control.edited_resource

static func set_value(control : Control, value = null):
	if !value:
		return
	
	if control is TextEdit:
		control.text = value 
	elif control is SpinBox:
		control.value = value
	elif control is CheckButton: 
		control.button_pressed = value
	elif control is CustomResourceLoader:
		control.path = value
	elif control is OptionButton:
		control.select(control.get_item_index(value))
	elif control is EditorResourcePicker:
		control.edited_resource = value
