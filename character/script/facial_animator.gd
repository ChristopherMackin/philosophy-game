@tool
extends Node

class_name FacialAnimator

@export_group("Emotion")
@export var emotion_index: Const.Emotion = Const.Emotion.REST:
	set(val):
		emotion_index = val
		pose_updated.call_deferred()
@export var override_eye_emotion: bool = false
@export var override_mouth_emotion: bool = false
@export var eye_emotion_set_count = 2
@export var mouth_phoneme_count = 13
var eye_starting_index: int:
	get:
		return eye_emotion_set_count * emotion_index

var eye_emotion_offset: Vector2:
	get:
		var val = Vector2((eye_starting_index % eye_col_count)/float(eye_col_count),
		floor(eye_starting_index / float(eye_row_count))/float(eye_col_count))
		return val


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
	
	offset += eye_emotion_offset
	offset = offset.clamp(Vector2.ZERO, Vector2.ONE)
	
	for m in eyes_meshes:
		var material = m.mesh.surface_get_material(0)
		if material is ShaderMaterial:
			material.set_shader_parameter("uv_offset", offset)
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
			material.set_shader_parameter("uv_offset", offset)
		else:
			material.uv1_offset = offset
