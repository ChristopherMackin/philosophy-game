extends Node3D

class_name Board3D

@export_group("Suit Track")
@export var suit_tracks : Array[SuitTrack3D]

@export_group("Packed Scene")
@export var token_3d_packed_scene : PackedScene

@export_group("Contestants")
@export var player : DebateContestant3D
@export var computer : DebateContestant3D

var lock : Lock = Lock.new()

func get_suit_track(token : Token):
	for track in suit_tracks:
		if track.tokens_3d.map(func(x): return x.token).find(token) >= 0: return track

func clear_row(amount : int):
	for i in amount:
		var remove_funcs : Array[Callable] = []
		
		for track in suit_tracks:
			remove_funcs.append(func(): await track.remove_token_at(0))
		
		Util.await_all(remove_funcs)

func update_board_3d(suit_track_dictionary : Dictionary, active_contestant : String):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	var contestant : DebateContestant3D = player if active_contestant == "player" else computer
	
	for track in suit_tracks:
		var suit = track.suit.name
	
		var current_tokens = track.tokens_3d.map(func(x): return x.token)
		var new_tokens = Util.array_difference(suit_track_dictionary[suit], current_tokens)
		var removed_tokens = Util.array_difference(current_tokens, suit_track_dictionary[suit])
		
		var add_funcs : Array[Callable] = []
		for token in new_tokens:
			add_funcs.append(func() :await _add_token(token, track, contestant))
		
		await Util.await_all(add_funcs)
		
		var remove_funcs : Array[Callable] = []
		for token in removed_tokens:
			remove_funcs.append(func() :await _remove_token(token, track, contestant))
		
		await Util.await_all(remove_funcs)
	
	lock.release_lock()

func _add_token(token : Token, suit_track : SuitTrack3D, contestant : DebateContestant3D):
	var token_3d : Token3D = token_3d_packed_scene.instantiate()
	get_tree().root.add_child(token_3d)
	token_3d.global_position = contestant.global_position
	
	token_3d.quaternion = suit_track.global_basis.get_rotation_quaternion()
	
	token_3d.set_texture(token)
	
	var token_tween = get_tree().create_tween().tween_property(token_3d, "global_position", suit_track.get_slot().global_position + Vector3(0,.002,0), contestant.play_duration)
	suit_track.tokens_3d.append(token_3d)
	await token_tween.finished

func _remove_token(token : Token, suit_track : SuitTrack3D, contestant : DebateContestant3D):
	var matching = suit_track.tokens_3d.filter(func (token_3d): return token == token_3d.token)
	var token_3d = matching[0] if not matching.is_empty() else null
	var index = suit_track.tokens_3d.find(token_3d)
	
	if index <0:
		return
	
	await suit_track.remove_token_at(index)
