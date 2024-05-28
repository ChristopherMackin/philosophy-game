extends Object

class_name ControlHelper

static func get_value(control : Control):
	if control is TextEdit:
		return control.text
	if control is SpinBox:
		return control.value
