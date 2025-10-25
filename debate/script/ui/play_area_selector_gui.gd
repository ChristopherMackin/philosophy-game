extends PlayAreaSelector

class_name PlayAreaSelectorGUI

@export_group("Packed Scene")
@export var selector_packed_scene : PackedScene

@export_group("Positioning")
@export var board : BoardGUI

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
	var tokens_gui : Array[TokenGUI]
	
	for key in board.suit_track_tokens_gui:
		var suit_track_gui = board.suit_track_tokens_gui[key]
		var track_tokens = suit_track_gui.map(func(x: TokenGUI): return x.token)
		for token in tokens:
			var index = track_tokens.find(token)
			if index >= 0:
				tokens_gui.append(suit_track_gui[index])
	
	for token_gui in tokens_gui:
		var selector : Control = selector_packed_scene.instantiate()
		add_child(selector)
		selector.global_position = token_gui.global_position + token_gui.size/2 * token_gui.get_global_transform_with_canvas().basis_xform(Vector2(1,1))
		selectors.append(selector)
		selector.token = token_gui.token
	
	Util.set_up_focus_connections(selectors)
	focus_group.focused_node = selectors[0]

func close_selector():
	_clear_card_container()
