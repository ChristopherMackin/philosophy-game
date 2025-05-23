@tool
extends Node

class_name FacialAnimator

@export_group("Eyes")
@export var eye_col_count: int = 4
@export var eye_row_count: int = 4
@export var eyes : MeshInstance3D
@export var eye_selector_bone_name: String = "eye_selector"
var eye_material : Material:
	get:
		return eyes.mesh.surface_get_material(0)

@export_group("Mouth")
@export var mouth_col_count: int = 4
@export var mouth_row_count: int = 4
@export var mouth : MeshInstance3D
@export var mouth_selector_bone_name: String = "mouth_selector"
var mouth_material : Material:
	get():
		return mouth.mesh.surface_get_material(0)

@export_group("Skeleton")
@export var skeleton : Skeleton3D

func pose_updated():
	update_eyes()
	update_mouth()

func update_eyes():
	var id = skeleton.find_bone(eye_selector_bone_name)
	var t = skeleton.get_bone_pose(id)
	
	var offset = Vector3(
		float(ceil(clamp(abs(t.origin.x), 0, 1) * eye_col_count) - 1) / eye_col_count,
		float(ceil(clamp(abs(t.origin.y), 0, 1) * eye_row_count) - 1) / eye_row_count,
		0
	)
	
	eye_material.uv1_offset = offset

func update_mouth():
	var id = skeleton.find_bone(mouth_selector_bone_name)
	var t = skeleton.get_bone_pose(id)
	
	var offset = Vector3(
		float(ceil(clamp(abs(t.origin.x), 0, 1) * mouth_col_count) - 1) / eye_col_count,
		float(ceil(clamp(abs(t.origin.y), 0, 1) * mouth_row_count) - 1) / mouth_row_count,
		0
	)
	
	mouth_material.uv1_offset = offset
