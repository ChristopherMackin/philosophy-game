extends Board

class_name Board3D

@export var view_port_board : ViewportBoard

@export_group("Packed Scene")
@export var token_3d_packed_scene : PackedScene

@export_group("Contestants")
@export var player : DebateContestant3D
@export var computer : DebateContestant3D

var suit_track_tokens_3d: Dictionary

var lock : Lock = Lock.new()

func clear_row(amount : int):
	for i in amount:
		var remove_funcs : Array[Callable] = []
		
		for track in view_port_board.suit_tracks:
			remove_funcs.append(func(): await track.remove_token_at(0))
		
		Util.await_all(remove_funcs)

func update_board(suit_track_dictionary : Dictionary, active_contestant : String):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	for key in suit_track_dictionary:
		if !suit_track_tokens_3d.has(key): suit_track_tokens_3d[key] = []
	
	var contestant : DebateContestant3D = player if active_contestant == "player" else computer
	
	for track in view_port_board.suit_tracks:
		var suit = track.suit.name
	
		var current_tokens = suit_track_tokens_3d[track.suit.name].map(func(x): return x.token)
		var new_tokens = Util.array_difference(suit_track_dictionary[suit], current_tokens)
		var removed_tokens = Util.array_difference(current_tokens, suit_track_dictionary[suit])
		
		var remove_funcs : Array[Callable] = []
		for token in removed_tokens:
			remove_funcs.append(func() :await _remove_token(token, track, contestant))
		
		await Util.await_all(remove_funcs)
		
		var add_funcs : Array[Callable] = []
		for token in new_tokens:
			add_funcs.append(func() :await _add_token(token, track, contestant))
		
		await Util.await_all(add_funcs)
	
	lock.release_lock()

func _add_token(token : Token, track: ViewportSuitTrack, contestant : DebateContestant3D):
	var token_3d : Token3D = token_3d_packed_scene.instantiate()
	get_tree().root.add_child(token_3d)
	token_3d.global_position = contestant.global_position
	
	token_3d.quaternion = self.global_basis.get_rotation_quaternion()
	
	token_3d.token = token
	
	var token_slot = track.slots[suit_track_tokens_3d[track.suit.name].size()]
	
	if token_slot != null:
		var token_tween = get_tree().create_tween().tween_property(token_3d, "global_position", token_slot.global_position + Vector3(0,.002,0), contestant.play_duration)
		suit_track_tokens_3d[track.suit.name].append(token_3d)
		await token_tween.finished
	else: token_3d.visible = false

func _remove_token(token : Token, suit_track : ViewportSuitTrack, contestant : DebateContestant3D):
	var matching = suit_track.tokens_3d.filter(func (token_3d): return token == token_3d.token)
	var token_3d = matching[0] if not matching.is_empty() else null
	var index = suit_track.tokens_3d.find(token_3d)
	
	if index <0:
		return
	
	await suit_track.remove_token_at(index)
