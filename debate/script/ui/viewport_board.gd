@tool
extends Board

class_name BoardGUI

@export var suit_track_parent : Control

@export_group("Debate Settings")
@export var debate_settings : DebateSettings:
	set(val):
		if debate_settings:
			debate_settings.on_value_changed.disconnect(create_suit_tracks)
		debate_settings = val
		
		if debate_settings:
			debate_settings.on_value_changed.connect(create_suit_tracks)
		
		create_suit_tracks.call_deferred()

@export_group("Packed Scene")
@export var token_gui_packed_scene : PackedScene
@export var suit_track_packed_scene : PackedScene:
	set(val):
		suit_track_packed_scene = val
		create_suit_tracks.call_deferred()

var suit_track_tokens_gui: Dictionary

var suit_tracks : Array[ViewportSuitTrack]

var lock : Lock = Lock.new()

func create_suit_tracks():
	for suit_track in suit_tracks:
		suit_track.queue_free()
	
	suit_tracks.clear()
	
	for suit in debate_settings.suits:
		var suit_track : ViewportSuitTrack = suit_track_packed_scene.instantiate()
		suit_track_parent.add_child(suit_track)
		suit_track.suit = suit
		suit_track.slot_count = debate_settings.slots
		
		suit_tracks.append(suit_track)

func clear_row(amount : int):
	for i in amount:
		var remove_funcs : Array[Callable] = []
		
		for suit in debate_settings.suits:
			var token_gui_track = suit_track_tokens_gui[suit.name]
			if debate_settings.line_clear_direction == Const.Direction.LEFT:
				remove_funcs.append(func(): await _remove_token(token_gui_track[0].token, suit))
			else:
				remove_funcs.append(func(): await _remove_token(token_gui_track[token_gui_track.size() - 1].token, suit))
		
		Util.await_all(remove_funcs)

func update_board(suit_track_dictionary : Dictionary, active_contestant : String):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	#Make sure keys all exist
	for key in suit_track_dictionary:
		if !suit_track_tokens_gui.has(key): suit_track_tokens_gui[key] = []
	
	for track in suit_tracks:
		var suit = track.suit
	
		var current_tokens = suit_track_tokens_gui[track.suit.name].map(func(x): return x.token)
		var new_tokens = Util.array_difference(suit_track_dictionary[suit.name], current_tokens)
		var removed_tokens = Util.array_difference(current_tokens, suit_track_dictionary[suit.name])
		
		var remove_funcs : Array[Callable] = []
		for token in removed_tokens:
			remove_funcs.append(func() :await _remove_token(token, suit))
		
		await Util.await_all(remove_funcs)
		
		var add_funcs : Array[Callable] = []
		for token in new_tokens:
			add_funcs.append(func() :await _add_token(token, suit))
		
		await Util.await_all(add_funcs)
	
	lock.release_lock()

func _add_token(token : Token, suit: Suit):
	var token_gui : TokenGUI = token_gui_packed_scene.instantiate()
	
	var track_index = suit_tracks.find_custom(func(x): return x.suit == suit)
	var track = suit_tracks[track_index]
	
	var current_slot = track.slots[suit_track_tokens_gui[suit.name].size()]
	
	current_slot.add_child(token_gui)
	
	token_gui.token = token
	
	suit_track_tokens_gui[suit.name].append(token_gui)
	
func _remove_token(token : Token, suit : Suit):
	var token_gui_track : Array = suit_track_tokens_gui[suit.name]
	
	var index = token_gui_track.map(func(x): return x.token).find(token)
	if index < 0: return
	
	var token_gui = token_gui_track[index]
	token_gui_track.remove_at(index)
	token_gui.queue_free()
	
	if range(index, token_gui_track.size()).size() <= 0: return
	
	var tween = get_tree().create_tween().set_parallel()
	
	for i in range(index, token_gui_track.size()):
		tween.tween_property(token_gui_track[i], "global_position", get_slot_global_position(suit, i), .4) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
	
	await tween.finished

func get_slot_global_position(suit: Suit, index: int):
	var track_index = suit_tracks.find_custom(func(x): return x.suit == suit)
	var track = suit_tracks[track_index]
	
	var current_slot = track.slots[index]

	return current_slot.global_position
