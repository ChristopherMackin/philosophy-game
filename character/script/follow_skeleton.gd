@tool
extends Node3D

class_name FollowSkeleton

func _ready():
	if !skeleton:
		var skeletons = find_children("*", "Skeleton3D", true)
		if not skeletons.is_empty():
			skeleton = skeletons[0]
	
	_pose_updated()

var skeleton: Skeleton3D:
	get:
		if skeleton == null:
			var skeletons = find_children("*", "Skeleton3D", true)
			if not skeletons.is_empty():
				skeleton = skeletons[0]
				
		return skeleton

@export var target: Skeleton3D:
	set(val):
		if target and target.pose_updated.is_connected(_pose_updated):
			target.pose_updated.disconnect(_pose_updated)
		
		target = val
		
		if target and !target.pose_updated.is_connected(_pose_updated):
			target.pose_updated.connect(_pose_updated)
		
		_pose_updated()

func _pose_updated():
	if !skeleton || !target: return
	
	for i in skeleton.get_bone_count():
		
		# Match the custom pose transforms from the animated master
		skeleton.set_bone_global_pose(i, target.get_bone_global_pose(i))
