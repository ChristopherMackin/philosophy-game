extends Board

class_name Board3D

@export var viewport_board : ViewportBoard
@export var board_sprite : Sprite3D

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
		
		for track in viewport_board.suit_tracks:
			remove_funcs.append(func(): await track.remove_token_at(0))
		
		Util.await_all(remove_funcs)

func update_board(suit_track_dictionary : Dictionary, active_contestant : String):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	#Make sure keys all exist
	for key in suit_track_dictionary:
		if !suit_track_tokens_3d.has(key): suit_track_tokens_3d[key] = []
	
	var contestant : DebateContestant3D = player if active_contestant == "player" else computer
	
	for track in viewport_board.suit_tracks:
		var suit_key = track.suit.name
	
		var current_tokens = suit_track_tokens_3d[track.suit.name].map(func(x): return x.token)
		var new_tokens = Util.array_difference(suit_track_dictionary[suit_key], current_tokens)
		var removed_tokens = Util.array_difference(current_tokens, suit_track_dictionary[suit_key])
		
		var remove_funcs : Array[Callable] = []
		for token in removed_tokens:
			remove_funcs.append(func() :await _remove_token(token, suit_key, contestant))
		
		await Util.await_all(remove_funcs)
		
		var add_funcs : Array[Callable] = []
		for token in new_tokens:
			add_funcs.append(func() :await _add_token(token, track, contestant))
		
		await Util.await_all(add_funcs)
	
	lock.release_lock()

func _add_token(token : Token, track: ViewportSuitTrack, contestant : DebateContestant3D):
	var slot_index = suit_track_tokens_3d[track.suit.name].size()
	
	if track.slots.size() <= slot_index: return
	
	var current_slot = track.slots[slot_index]
	
	var face_position = board_sprite.pixel_size * ((current_slot.global_position + current_slot.size / 2) - viewport_board.size/2)
	var local_position = Vector3(face_position.x, .002, face_position.y)
	
	var token_3d : Token3D = token_3d_packed_scene.instantiate()
	self.add_child(token_3d)
	
	token_3d.token = token
	token_3d.position = local_position
	token_3d.quaternion = self.global_basis.get_rotation_quaternion()
	
	suit_track_tokens_3d[track.suit.name].append(token_3d)
	
func _remove_token(token : Token, suit_key : String, contestant : DebateContestant3D):
	var token_3d_track : Array = suit_track_tokens_3d[suit_key]
	
	var index = token_3d_track.map(func(x): return x.token).find(token)
	if index < 0: return
	
	var token_3d = token_3d_track[index]
	token_3d_track.remove_at(index)
	token_3d.queue_free()
