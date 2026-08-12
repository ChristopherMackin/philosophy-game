extends Node3D

class_name Token3d

@onready var mesh_instance: MeshInstance3D = $Token

var token: Token:
	set(val):
		token = val
		if !token || !token.artwork: return
	
		_texture = token.artwork

var _texture: Texture2D:
	set(val):
		_texture = val
		if !_texture: return
		
		mesh_instance.material_override = mesh_instance.get_active_material(0).duplicate()
		mesh_instance.material_override.albedo_texture = _texture
