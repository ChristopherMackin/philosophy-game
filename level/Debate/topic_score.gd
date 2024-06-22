extends VBoxContainer

class_name TopicScore

@export var segment_count : int:
	set(value):
		segment_count = value
		for pose_score : PoseScore in pose_score_array:
			pose_score.segment_count = segment_count

@export var topic : Topic:
	set(value):
		topic = value
		
		for pose_score in pose_score_array:
			pose_score.queue_free()
		pose_score_array.clear()
		
		for pose in topic.poses if topic else []:
			var pose_score : PoseScore = pose_score_prefab.instantiate()
			pose_container.add_child(pose_score)
			pose_score.segment_count = segment_count
			pose_score.pose = pose
			pose_score_array.append(pose_score)

@export var pose_container : Control

@export var pose_score_prefab : PackedScene

var pose_score_array : Array[PoseScore]
