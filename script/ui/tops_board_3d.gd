extends Node3D

class_name TopsBoard3D

@export_group("Pose Settings")
@export var settings : DebateSettings
@export var pose_tracks : Array[PoseTrack3D]

@export_group("Packed Scene")
@export var top_3d_packed_scene : PackedScene
@export var tops_card_3d_pose_packed_scenes : Array[PosePackedScene]

@export_group("Tops")
@export var discard : Discard3D

@export_group("Contestants")
@export var player : DebateContestant3D
@export var computer : DebateContestant3D

var lock : Lock = Lock.new()

func get_pose_track(pose : Pose):
	for track in pose_tracks:
		if track.pose == pose: return track

func clear_row(amount : int):
	for i in amount:
		var remove_funcs : Array[Callable] = []
		
		for track in pose_tracks:
			remove_funcs.append(func(): await track.remove_top_at(0))
		
		Util.await_all(remove_funcs)

func update_tops_board_3d(pose_track_dictionary : Dictionary, active_contestant : String):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	var contestant : DebateContestant3D = player if active_contestant == "player" else computer
	
	for track in pose_tracks:
		var pose = track.pose.name
	
		var current_tops = track.tops_3d.map(func(x): return x.top)
		var new_cards = Util.array_difference(pose_track_dictionary[pose], current_tops)
		var removed_cards = Util.array_difference(current_tops, pose_track_dictionary[pose])
		
		var add_funcs : Array[Callable] = []
		for top in new_cards:
			add_funcs.append(func() :await _add_top(top, contestant))
		
		await Util.await_all(add_funcs)
		
		var remove_funcs : Array[Callable] = []
		for top in removed_cards:
			remove_funcs.append(func() :await _remove_top(top, contestant))
		
		await Util.await_all(remove_funcs)
	
	lock.release_lock()

func _add_top(top : Top, contestant : DebateContestant3D):
	
	#Discard top card
	var index = tops_card_3d_pose_packed_scenes.map(func(x): return x.pose).find(top.data.pose)
	index = index if index >= 0 else 0
	var tops_card_3d_packed_scene = tops_card_3d_pose_packed_scenes[index].packed_scene
	
	var tops_card : TopsCard3D = tops_card_3d_packed_scene.instantiate() as TopsCard3D
	discard.add_child(tops_card)
	
	tops_card.set_top(top)
	
	#This will be replaced with a more suitable procedural animation 
	tops_card.global_position = contestant.global_position + Vector3(0, 1, 0)
	tops_card.rotation.z = contestant.get_random_rotation_rad()
	
	var card_tween = get_tree().create_tween().tween_property(tops_card, "global_position", discard.global_position + Vector3(0, .001, 0) * discard.get_child_count(), contestant.play_duration)
	await card_tween.finished
	
	#Play top on board
	var top_3d : Top3D = top_3d_packed_scene.instantiate()
	var track = get_pose_track(top.data.pose)
	get_tree().root.add_child(top_3d)
	top_3d.global_position = contestant.global_position
	
	top_3d.quaternion = track.global_basis.get_rotation_quaternion()
	
	#top_3d.reparent(track)
	
	top_3d.set_top_texture(top)
	#This will be replaced with a more suitable procedural animation 
	
	var top_tween = get_tree().create_tween().tween_property(top_3d, "global_position", track.get_top_slot().global_position + Vector3(0,.002,0), contestant.play_duration)
	track.tops_3d.append(top_3d)
	await top_tween.finished

func _remove_top(top : Top, contestant : DebateContestant3D):
	var track = get_pose_track(top.data.pose)
	var matching = track.tops_3d.filter(func (top_3d): return top == top_3d.top)
	var top_3d = matching[0] if not matching.is_empty() else null
	var top_index = track.tops_3d.find(top_3d)
	
	if top_index <0:
		return
	
	await track.remove_top_at(top_index)
