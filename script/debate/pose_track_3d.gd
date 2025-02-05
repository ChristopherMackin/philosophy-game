extends Node

class_name PoseTrack3D

@export var slots : Array[Node]
@export var pose : Pose
var tops_3d: Array[Top3D]

func get_top_slot():
	return slots[tops_3d.size()]

func remove_top(top : Top):
	pass

func remove_top_at(index : int):
	if index >= tops_3d.size():
		return
	
	tops_3d[index].queue_free()
	tops_3d.remove_at(index)
	
	var tween = get_tree().create_tween().set_parallel()
	
	if range(index, tops_3d.size()).size() <= 0: return
	
	for i in range(index, tops_3d.size()):
		tween.tween_property(tops_3d[i], "global_position", slots[i].global_position +  + Vector3(0,.002,0), .4) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
	
	await tween.finished
