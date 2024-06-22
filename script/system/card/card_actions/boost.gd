extends CardAction

class_name Boost

@export var boost_amount : int = 1

func positive_action(manager: DebateManager):
	var pose = manager.current_pose
	manager.update_pose_score(pose, boost_amount)

func negative_action(manager: DebateManager):
	var pose = manager.current_pose
	manager.update_pose_score(pose, -boost_amount)
