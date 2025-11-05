extends Node

class_name CardFocusAnimation

@export var exposed_control_methods: ExposedControlMethods

func _on_focus_entered():
	exposed_control_methods.set_global_rotation(0)
	exposed_control_methods.set_z_index(1)
	exposed_control_methods.set_position(Vector2(0, -100))

func _on_focus_exited():
	exposed_control_methods.set_rotation(0)
	exposed_control_methods.set_z_index(0)
	exposed_control_methods.set_position(Vector2.ZERO)
