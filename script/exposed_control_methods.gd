extends Node

class_name ExposedControlMethods

@export var root : Control

func set_scale(val : Vector2):
	root.scale = val

func set_z_index(val : int):
	root.z_index = val

func set_modulate(val : Color):
	root.modulate = val
