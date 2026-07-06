extends Node3D

class_name GameBoard3d

@onready var _token_tracks: Array[TokenTrack3d] = get_token_tracks()

func get_token_tracks() -> Array[TokenTrack3d]:
	var result: Array[TokenTrack3d] = []
	for child in get_children():
		if is_instance_of(child, TokenTrack3d): # Replace Sprite2D with your desired type
			result.append(child)
	return result

func update_token_tracks(suit_track_dictionary: Dictionary):
	for suit in suit_track_dictionary:
		var index = _token_tracks.find_custom(func(x: TokenTrack3d): return x.suit.name == suit)
		if index != -1: 
			var track = _token_tracks[index]
			track.update_token_track(suit_track_dictionary[suit])
