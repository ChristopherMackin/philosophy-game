extends Node3D

class_name TopsBoard3D

@export var settings : DebateSettings
@export var pose_tracks : Array[PoseTrack3D]

func get_pose_track(top : Top) -> PoseTrack3D:
	var index = settings.poses.find(top.data.pose)
	
	if index > pose_tracks.size() || index < 0: return
	
	return pose_tracks[index]

func remove_top_3D(top : Top):
	pass

func clear_row(amount : int):
	for i in amount:
		var remove_funcs : Array[Callable] = []
		
		for track in pose_tracks:
			remove_funcs.append(func(): await track.remove_top_at(0))
		
		Util.await_all(remove_funcs)
