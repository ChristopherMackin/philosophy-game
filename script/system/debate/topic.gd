extends Resource

class_name Topic

@export var name : String
@export var poses : Array[Pose]

func has_pose(pose):
	return poses.has(pose)
