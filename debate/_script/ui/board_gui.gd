@tool
extends Board

#class_name BoardGUI

@export var suit_track_parent : Control

@export_group("Debate Settings")
@export var debate_settings : DebateSettings:
	set(val):
		if debate_settings:
			debate_settings.on_value_changed.disconnect(_reformat_board)
		debate_settings = val
		
		if debate_settings:
			debate_settings.on_value_changed.connect(_reformat_board)
		
		_reformat_board.call_deferred()

@export_group("Packed Scene")
@export var token_gui_packed_scene : PackedScene

var suit_track_gui: Dictionary

var lock : Lock = Lock.new()

func _reformat_board():
	var i := 0
	for suit in debate_settings.suits:
		suit_track_gui[suit.name] = suit_track_parent.get_child(i)
		i+=1

func _reformat_row():
	pass

func update_board(suit_track_dictionary : Dictionary, _active_contestant : String):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	#Don't display non-used tracks
	for key in suit_track_gui:
		if !suit_track_dictionary.has(key): suit_track_dictionary[key] = []
	
	for suit_name in suit_track_gui:
		var track_tokens_gui = get_track_tokens_gui(suit_name)
		var track_tokens = track_tokens_gui.map(func(x): return x.token)

		#debate manager tokens
		var dm_tokens = suit_track_dictionary[suit_name]
		
		var new_tokens = Util.array_difference(dm_tokens, track_tokens)
		var removed_tokens = Util.array_difference(track_tokens, dm_tokens)
		
		var remove_funcs : Array[Callable] = []
		for token in removed_tokens:
			remove_funcs.append(func() :await _remove_token(token, suit_name))
		
		await Util.await_all(remove_funcs)
		
		var add_funcs : Array[Callable] = []
		for token in new_tokens:
			add_funcs.append(func() :await _add_token(token, suit_name))
		
		await Util.await_all(add_funcs)
	
	lock.release_lock()

func _add_token(token : Token, suit_name: String):
	var token_gui : TokenGUI = token_gui_packed_scene.instantiate()
	
	var track = suit_track_gui[suit_name]
	
	var current_slot = track.get_children()[get_track_tokens_gui(suit_name).size()]
	
	current_slot.add_child(token_gui)
	
	token_gui.token = token
	
func _remove_token(token : Token, suit_name : String):
	var token_gui_track : Array = suit_track_gui[suit_name]
	
	var index = token_gui_track.map(func(x): return x.token).find(token)
	if index < 0: return
	
	var token_gui = token_gui_track[index]
	token_gui_track.remove_at(index)
	token_gui.queue_free()
	
	if range(index, token_gui_track.size()).size() <= 0: return
	
	var tween = get_tree().create_tween().set_parallel()
	
	for i in range(index, token_gui_track.size()):
		tween.tween_property(token_gui_track[i], "global_position", get_slot_global_position(suit_name, i), .4) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
	
	await tween.finished

func get_slot_global_position(suit_name: String, index: int):
	var track = suit_track_gui[suit_name]
	
	var current_slot = track.slots[index]

	return current_slot.global_position

func get_track_tokens_gui(suit_name: String):
	var track_slots = suit_track_gui[suit_name].get_children()
	return track_slots.map(func(x: Node):
		if x.get_child_count() > 0:
			return x.get_child(0) 
	).filter(func(x: Node): return x != null)
