@tool
extends Node

class_name FacialAnimator

@export_group("Eyes")
@export var eye_col_count: int = 4
@export var eye_row_count: int = 4
@export var eyes_meshes : Array[MeshInstance3D] = []
@export var eye_selector_bone_name: String = "eye_selector"

@export_group("Mouth")
@export var mouth_col_count: int = 4
@export var mouth_row_count: int = 4
@export var mouth_meshes : Array[MeshInstance3D]
@export var mouth_selector_bone_name: String = "mouth_selector"

@export_group("Skeleton")
@export var skeleton : Skeleton3D

func pose_updated():
	update_eyes()
	update_mouth()

func update_eyes():
	var id = skeleton.find_bone(eye_selector_bone_name)
	var t = skeleton.get_bone_pose(id).origin
	var r = skeleton.get_bone_rest(id).origin
	var origin = (t - r).clamp(Vector3.ZERO, Vector3.ONE)
	
	var offset = Vector2(
		float(ceil(max(origin.x * eye_col_count, 1)) - 1) / eye_col_count,
		float(ceil(max(origin.y * eye_row_count, 1)) - 1) / eye_row_count,
	)
	
	for m in eyes_meshes:
		var material = m.mesh.surface_get_material(0)
		if material is ShaderMaterial:
			m.set_instance_shader_parameter("uv_offset", offset)
		else:
			material.uv1_offset = offset


func update_mouth():
	var id = skeleton.find_bone(mouth_selector_bone_name)
	var t = skeleton.get_bone_pose(id)
	var r = skeleton.get_bone_rest(id)
	var origin = (t.origin - r.origin).clamp(Vector3.ZERO, Vector3.ONE)
	
	var offset = Vector3(
		float(ceil(max(origin.x * mouth_col_count, 1)) - 1) / mouth_col_count,
		float(ceil(max(origin.y * mouth_row_count, 1)) - 1) / mouth_row_count,
		0
	)
	
	for m in mouth_meshes:
		var material = m.mesh.surface_get_material(0)
		if material is ShaderMaterial:
			m.set_instance_shader_parameter("uv_offset", offset)
		else:
			material.uv1_offset = offset
