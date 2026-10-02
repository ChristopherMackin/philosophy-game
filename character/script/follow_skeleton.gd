@tool
extends Node3D

class_name FollowSkeleton

func _ready():
	if !skeleton:
		var skeletons = find_children("*", "Skeleton3D", true)
		if not skeletons.is_empty():
			skeleton = skeletons[0]
	
	_update_modifiers()
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
		Util.optional_disconnect(target, "pose_updated", _pose_updated)
		Util.optional_disconnect(target, "child_order_changed", _update_modifiers)
		
		target = val
		
		Util.optional_connect(target, "pose_updated", _pose_updated)
		Util.optional_connect(target, "child_order_changed", _update_modifiers)
		
		_update_modifiers()
		_pose_updated()

var modifiers: Array[SkeletonModifier3D]

func _update_modifiers():
	var modifier_children: Array[SkeletonModifier3D] 
	modifier_children.assign(find_children("*", "SkeletonModifier3D", true, false))
	
	var added = Util.array_difference(modifier_children, modifiers)
	var removed = Util.array_difference(modifiers, modifier_children)
		
	for modifier: SkeletonModifier3D in added:
		Util.optional_connect(modifier, "modification_processed", _pose_updated)
	
	for modifier: SkeletonModifier3D in removed:
		Util.optional_disconnect(modifier, "modification_processed", _pose_updated)
	
	modifiers = modifier_children

func _pose_updated():
	if !skeleton || !target: return
	
	for i in skeleton.get_bone_count():
		
		# Match the custom pose transforms from the animated master
		skeleton.set_bone_global_pose(i, target.get_bone_global_pose(i))
