extends Node

class_name ExposedControlMethods

@export var root : Control

func set_scale(scale : Vector2):
	root.scale = scale

func set_z_index(index : int):
	root.z_index = index

func set_modulate(color : Color):
	root.modulate = color

func set_position(position: Vector2):
	root.position = position

func set_global_rotation(degrees: float):
	root.rotation_degrees = degrees - rad_to_deg(root.get_global_transform_with_canvas().basis_xform(Vector2.RIGHT).angle())

func set_rotation(degrees: float):
	root.rotation_degrees = degrees
