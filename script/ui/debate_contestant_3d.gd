extends Node3D

class_name DebateContestant3D

@export var emotion_index : int:
	set(val):
		emotion_index = val
		(func ():
			facial_animator.emotion_index = emotion_index
			).call_deferred()

@export var facial_animator : FacialAnimator

@export_group("Packed Scene")
@export var top_3d_packed_scene : PackedScene
@export var tops_card_3d_pose_packed_scenes : Array[PosePackedScene]

@export_group("Tops")
@export var discard : Discard3D
@export var tops_board : TopsBoard3D

@export var max_random_rotation_degrees : float
@export var play_duration : float = 1

func get_random_rotation_rad():
	var angle = randf_range(0, max_random_rotation_degrees)
	var angle_rad = deg_to_rad(angle)
	var sign : bool = randi_range(0, 1) == 0
	
	return angle_rad if sign else -angle_rad

func play_top(top : Top):
	#Discard top card
	var index = tops_card_3d_pose_packed_scenes.map(func(x): return x.pose).find(top.data.pose)
	index = index if index >= 0 else 0
	var tops_card_3d_packed_scene = tops_card_3d_pose_packed_scenes[index].packed_scene
	
	var tops_card : TopsCard3D = tops_card_3d_packed_scene.instantiate() as TopsCard3D
	discard.add_child(tops_card)
	
	tops_card.set_top(top)
	#This will be replaced with a more suitable procedural animation 
	tops_card.global_position = global_position + Vector3(0, 1, 0)
	tops_card.rotation.z = get_random_rotation_rad()
	
	var card_tween = get_tree().create_tween().tween_property(tops_card, "global_position", discard.global_position + Vector3(0, .001, 0) * discard.get_child_count(), play_duration)
	await card_tween.finished
	
	#Play top on board
	var top_3d : Top3D = top_3d_packed_scene.instantiate()
	var track = tops_board.get_pose_track(top)
	get_tree().root.add_child(top_3d)
	top_3d.reparent(track, true)
	
	top_3d.set_top_texture(top)
	#This will be replaced with a more suitable procedural animation 
	top_3d.global_position = global_position + Vector3(0, 1, 0)

	var top_tween = get_tree().create_tween().tween_property(top_3d, "global_position", track.get_top_slot().global_position + Vector3(0,.002,0), play_duration)
	track.tops_3d.append(top_3d)
	await top_tween.finished
