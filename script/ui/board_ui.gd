extends Board

class_name BoardUI

@export var suit_track_parent : Control

@export_group("Debate Settings")
@export var debate_settings : DebateSettings

@export_group("Packed Scene")
@export var suit_track_packed_scene : PackedScene

var suit_tracks : Array[SuitTrackUI]

var lock : Lock = Lock.new()

func _ready():
	for suit in debate_settings.suits:
		var suit_track : SuitTrackUI = suit_track_packed_scene.instantiate()
		suit_track_parent.add_child(suit_track)
		suit_track.init(suit, debate_settings.slots)
		suit_tracks.append(suit_track)

func clear_row(amount : int):
	for i in amount:
		var remove_funcs : Array[Callable] = []
		
		for track in suit_tracks:
			if debate_settings.line_clear_direction == Const.Direction.RIGHT:
				remove_funcs.append(func(): await track.remove_token_at(track.tokens_ui.size() - 1))
			else:
				remove_funcs.append(func(): await track.remove_token_at(0))

		
		Util.await_all(remove_funcs)

func update_board(suit_track_dictionary : Dictionary, active_contestant : String):
	while(!lock.obtain_lock()):
		await lock.on_released
	
	for track : SuitTrackUI in suit_tracks:
		var suit = track.suit.name
	
		var current_tokens = track.tokens_ui.map(func(x): return x.token)
		var new_tokens = Util.array_difference(suit_track_dictionary[suit], current_tokens)
		var removed_tokens = Util.array_difference(current_tokens, suit_track_dictionary[suit])
		
		var remove_funcs : Array[Callable] = []
		for token in removed_tokens:
			remove_funcs.append(func() :await track.remove_token(token))
		
		await Util.await_all(remove_funcs)
		
		var add_funcs : Array[Callable] = []
		for token in new_tokens:
			add_funcs.append(func() :await track.add_token(token))
		
		await Util.await_all(add_funcs)
	
	lock.release_lock()
