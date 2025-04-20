extends Board

class_name Board3D

@export var viewport_board : ViewportBoard
@export var board_sprite : Sprite3D
@export var debate_settings: DebateSettings

@export_group("Packed Scene")
@export var token_3d_packed_scene : PackedScene

var suit_track_tokens_3d: Dictionary

var lock : Lock = Lock.new()

func clear_row(amount : int):
	for i in amount:
		var remove_funcs : Array[Callable] = []
		
		for suit in debate_settings.suits:
			var token_3d_track = suit_track_tokens_3d[suit.name]
			if debate_settings.line_clear_direction == Const.Direction.LEFT:
				remove_funcs.append(func(): await _remove_token(token_3d_track[0].token, suit))
			else:
				remove_funcs.append(func(): await _remove_token(token_3d_track[token_3d_track.size() - 1].token, suit))
		
		Util.await_all(remove_funcs)

func update_board(suit_track_dictionary : Dictionary, active_contestant : String):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	#Make sure keys all exist
	for key in suit_track_dictionary:
		if !suit_track_tokens_3d.has(key): suit_track_tokens_3d[key] = []
	
	for track in viewport_board.suit_tracks:
		var suit = track.suit
	
		var current_tokens = suit_track_tokens_3d[track.suit.name].map(func(x): return x.token)
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
	var token_3d : Token3D = token_3d_packed_scene.instantiate()
	self.add_child(token_3d)
	
	token_3d.token = token
	token_3d.position = get_slot_local_position(suit, suit_track_tokens_3d[suit.name].size())
	token_3d.quaternion = self.global_basis.get_rotation_quaternion()
	
	suit_track_tokens_3d[suit.name].append(token_3d)
	
func _remove_token(token : Token, suit : Suit):
	var token_3d_track : Array = suit_track_tokens_3d[suit.name]
	
	var index = token_3d_track.map(func(x): return x.token).find(token)
	if index < 0: return
	
	var token_3d = token_3d_track[index]
	token_3d_track.remove_at(index)
	token_3d.queue_free()
	
	if range(index, token_3d_track.size()).size() <= 0: return
	
	var tween = get_tree().create_tween().set_parallel()
	
	for i in range(index, token_3d_track.size()):
		tween.tween_property(token_3d_track[i], "position", get_slot_local_position(suit, i), .4) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
	
	await tween.finished

func get_slot_local_position(suit: Suit, index: int):
	var track_index = viewport_board.suit_tracks.find_custom(func(x): return x.suit == suit)
	var track = viewport_board.suit_tracks[track_index]
	
	var current_slot = track.slots[index]

	var face_position = board_sprite.pixel_size * (current_slot.global_position + current_slot.size / 2 - viewport_board.size/2)
	return Vector3(face_position.x, .002, face_position.y)
