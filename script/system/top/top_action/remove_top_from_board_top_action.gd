extends TopAction

class_name RemoveTopFromBoardTopAction

@export var allowedPoses : Array[Pose]

func invoke(top : Top, player : Contestant, manager : DebateManager):
	var selectable_tops : Array[Top]
	
	for pose in allowedPoses:
		selectable_tops.append_array(manager.pose_track_dictionary[pose.name])
	
	var selected_top = await player.select_top(
		selectable_tops,
		"board_top_removal",
		true
	)
	
	manager.remove_top_from_queue(selected_top)
