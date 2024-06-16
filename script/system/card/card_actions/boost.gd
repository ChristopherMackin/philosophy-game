extends CardAction

class_name Boost

@export var boost_amount : int = 1

func positive_action(manager: DebateManager):
	var pose = manager.current_pose
	manager.pose_score_dictionary[pose.name] += 1

func negative_action(manager: DebateManager):
	var pose = manager.current_pose
	manager.pose_score_dictionary[pose.name] -= 1
