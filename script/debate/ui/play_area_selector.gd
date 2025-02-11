extends Control

class_name PlayAreaSelector

@export var board : Board3D

@export var camera : Camera3D
@export var selector_packed_scene : PackedScene
@export var focus_group : FocusGroup

var selectors : Array[Node3DSelectorUI]

func _clear_card_container():
	for selector in selectors: selector.queue_free()
	selectors.clear()

func open_selector(tokens : Array[Token]):
	var tokens_3d : Array[Token3D]
	
	for suit_track in board.suit_tracks:
		for token in tokens:
			var index = suit_track.map(func(x): return x.token).find(token)
			if index >= 0:
				tokens_3d.append(suit_track[index])
	
	for token_3d in tokens_3d:
		var selector : Control = selector_packed_scene.instantiate()
		add_child(selector)
		selector.position = camera.unproject_position(token_3d.global_position)
		selectors.append(selector)
		selector.token = token_3d.token
	
	Util.set_up_focus_connections(selectors)
	focus_group.focused_node = selectors[0]

func close_selector():
	_clear_card_container()
