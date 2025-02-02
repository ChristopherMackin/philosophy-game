extends Node3D

class_name Top3D

@export var mesh_instance : MeshInstance3D

var top : Top

func set_top_texture(top : Top):
	self.top = top
	
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = top.data.artwork
	mesh_instance.set_surface_override_material(0, mat)
