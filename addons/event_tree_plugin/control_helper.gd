extends Object

class_name ControlHelper

static func get_value(control : Control):
	if control is TextEdit:
		return control.text
	if control is SpinBox:
		return control.value

static func set_value(control : Control, value):
	if control is TextEdit:
		control.text = value
	if control is SpinBox:
		control.value = value
