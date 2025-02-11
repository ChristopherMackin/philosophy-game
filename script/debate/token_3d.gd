extends Node3D

class_name Token3D

@export var mesh_instance : MeshInstance3D

var token : Token

func set_texture(token : Token):
	self.token = token
	
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = token.data.artwork
	mesh_instance.set_surface_override_material(0, mat)
