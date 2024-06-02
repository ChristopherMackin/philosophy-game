extends Object

class_name ControlHelper

static func get_value(control : Control):
	if control is TextEdit:
		return control.text
	if control is SpinBox:
		return control.value
	if control is CheckButton:
		return control.button_pressed

static func set_value(control : Control, value):
	if !value:
		return
	
	if control is TextEdit:
		control.text = value 
	if control is SpinBox:
		control.value = value
	if control is CheckButton: 
		control.button_pressed = value
