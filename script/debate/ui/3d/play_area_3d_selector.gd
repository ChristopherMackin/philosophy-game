extends PlayAreaSelector

class_name PlayArea3DSelector

@export_group("Packed Scene")
@export var selector_packed_scene : PackedScene

@export_group("3D Positioning")
@export var board : Board3D
@export var camera : Camera3D

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain

var selectors : Array[TokenSelectorGUI]

func _ready():
	focus_group.on_select.connect(on_select)

func on_select(data, what: String, focus_type : String):
	if what != "play":
		return
	
	if player_brain.make_selection(SelectionResponse.new(data, what)):
		close_selector()

func _clear_card_container():
	for selector in selectors: selector.queue_free()
	selectors.clear()

func open_selector(tokens : Array[Token]):
	var tokens_3d : Array[Token3D]
	
	for key in board.suit_track_tokens_3d:
		var token_3d_track = board.suit_track_tokens_3d[key]
		for token in tokens:
			var index = token_3d_track.map(func(x): return x.token).find(token)
			if index >= 0:
				tokens_3d.append(token_3d_track[index])
	
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
