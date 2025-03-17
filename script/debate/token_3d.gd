extends Node3D

class_name Token3D

@export var mesh_instance : MeshInstance3D

var token : Token:
	get: return token
	set(val):
		token = val
		if val != null:
			_set_texture(token)

func _set_texture(token : Token):
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = token.artwork
	mesh_instance.set_surface_override_material(0, mat)
