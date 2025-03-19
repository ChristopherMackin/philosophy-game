extends PlayAreaSelector

class_name PlayAreaUISelector

@export_group("Packed Scene")
@export var selector_packed_scene : PackedScene

@export_group("Positioning")
@export var board : BoardUI

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain

var selectors : Array[TokenSelectorUI]

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
	var ui_tokens : Array[TokenUI]
	
	for suit_track in board.suit_tracks:
		for token in tokens:
			var index = suit_track.tokens_ui.map(func(x): return x.token).find(token)
			if index >= 0:
				ui_tokens.append(suit_track.tokens_ui[index])
	
	for ui_token in ui_tokens:
		var selector : Control = selector_packed_scene.instantiate()
		add_child(selector)
		selector.global_position = ui_token.global_position + ui_token.size/2
		selectors.append(selector)
		selector.token = ui_token.token
	
	Util.set_up_focus_connections(selectors)
	focus_group.focused_node = selectors[0]

func close_selector():
	_clear_card_container()
