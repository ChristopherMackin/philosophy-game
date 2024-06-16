@tool
extends Resource

class_name DebateSettings

@export var topic_array : Array[Topic]

@export var win_amount : int = 5

enum PoseRelationship {
	SAME,
	OPPOSING,
	OFF_TOPIC,
	NONE,
}

func has_pose(pose : Pose) -> bool:
	for topic : Topic in topic_array:
		if topic.has_pose(pose):
			return true
	
	return false

func get_topic_index(pose : Pose) -> int:
	var index = 0
	
	for topic : Topic in topic_array:
		if topic.has_pose(pose):
			return index
		
		index += 1
	
	return -1

func get_topic(pose : Pose) -> Topic:
	var index = get_topic_index(pose)
	
	if index == -1:
		return null
	
	return topic_array[index]

func conflicting(pose_1 : Pose, pose_2 : Pose) -> bool:
	for topic : Topic in topic_array:
		if topic.has_pose(pose_1) and topic.has_pose(pose_2) and pose_1 != pose_2:
			return true
		
	return false

func get_pose_relationship(pose_1 : Pose, pose_2 : Pose) -> PoseRelationship:
	if pose_1 == pose_2:
		return PoseRelationship.SAME
	elif (conflicting(pose_1, pose_2)):
		return PoseRelationship.OPPOSING
	elif has_pose(pose_1) and has_pose(pose_2):
		return PoseRelationship.OFF_TOPIC
	
	return PoseRelationship.NONE
