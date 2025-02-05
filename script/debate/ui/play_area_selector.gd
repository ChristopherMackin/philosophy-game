extends Control

class_name PlayAreaSelector

@export var tops_board : TopsBoard3D

@export var camera : Camera3D
@export var selector_packed_scene : PackedScene
@export var focus_group : FocusGroup

var selectors : Array[Node3DSelectorUI]

func _clear_card_container():
	for selector in selectors: selector.queue_free()
	selectors.clear()

func open_selector(tops : Array[Top]):
	var tops_3d : Array[Top3D]
	for top in tops:
		var pose_track_tops_3d : Array[Top3D] = tops_board.get_pose_track(top.data.pose).tops_3d
		var index = pose_track_tops_3d.map(func(x): return x.top).find(top)
		if index >= 0:
			tops_3d.append(pose_track_tops_3d[index])
	
	for top_3d in tops_3d:
		var selector : Control = selector_packed_scene.instantiate()
		add_child(selector)
		selector.position = camera.unproject_position(top_3d.global_position)
		selectors.append(selector)
		selector.top = top_3d.top
	
	Util.set_up_focus_connections(selectors)
	focus_group.focused_node = selectors[0]

func close_selector():
	_clear_card_container()
