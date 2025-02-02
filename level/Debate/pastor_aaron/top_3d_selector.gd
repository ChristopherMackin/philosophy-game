extends Control

@export var camera : Camera3D
@export var node3D : Node3D

func _process(delta):
	position = camera.unproject_position(node3D.global_position) 
