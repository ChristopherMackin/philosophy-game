extends NodeBasedDebateSubscriber

class_name GameBoard3d

@onready var _token_tracks: Array[TokenTrack3d] = get_token_tracks()

@export_category("Delay")
@export var seconds_placement_delay: float = 3
var _update_queue: Queue = Queue.new()

var is_running:= false

var previous_dictionary:= {}

signal queue_empty

func _ready():
	super._ready()

func get_tokens_3d() -> Array[Token3d]:
		if _update_queue.size() >= 0:
			await queue_empty
		
		var return_tokens_3d: Array[Token3d] = []
		var tokens_per_track = _token_tracks.map(func(x: TokenTrack3d): return x.tokens_3d)
		for tokens in tokens_per_track:
			return_tokens_3d += tokens
		
		return return_tokens_3d

func get_token_tracks() -> Array[TokenTrack3d]:
	var result: Array[TokenTrack3d] = []
	for child in get_children():
		if is_instance_of(child, TokenTrack3d): # Replace Sprite2D with your desired type
			result.append(child)
	return result

func _update_token_tracks(suit_track_dictionary: Dictionary):
	var current_dictionary = suit_track_dictionary.duplicate(true)
	var repeat = true
	
	if current_dictionary.keys() == previous_dictionary.keys():
		for key in current_dictionary:
			if Util.array_difference(previous_dictionary[key], current_dictionary[key]).size() > 0 || Util.array_difference(current_dictionary[key], previous_dictionary[key]).size() > 0:
				repeat = false
				break
	else: repeat = false
	
	if repeat: return
	
	previous_dictionary = current_dictionary
	_update_queue.push(current_dictionary)
	if !is_running:
		_process_suit_track_queue()
	

func _process_suit_track_queue():
	is_running = true
		
	while _update_queue.size() > 0:
		var x = _update_queue.pop()
		var callables: Array[Callable] = []
		for suit in x:
			var index = _token_tracks.find_custom(func(x: TokenTrack3d): return x.suit.name == suit)
			if index != -1: 
				callables.append(func():
					var track = _token_tracks[index]
					if track.remove_tokens(x[suit]):
						await GlobalTimer.wait_for_seconds(seconds_placement_delay)
					if track.add_tokens(x[suit]):
						await GlobalTimer.wait_for_seconds(seconds_placement_delay)
					if track.move_tokens(x[suit]):
						await GlobalTimer.wait_for_seconds(seconds_placement_delay)

				)
		
		await Util.await_all(callables)
	
	queue_empty.emit()
	
	is_running = false

func on_token_played(token: Token, suit: Suit, contestant : Contestant): _update_from_suit_track_dictionary()

func on_actions_invoked(card : Card, action_type: CardAction.Type, contestant : Contestant): _update_from_suit_track_dictionary()

func _update_from_suit_track_dictionary(): _update_token_tracks(manager.suit_track_dictionary)
