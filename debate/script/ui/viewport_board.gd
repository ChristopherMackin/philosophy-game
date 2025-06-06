@tool
extends Board

class_name ViewportBoard

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
@export var suit_track_packed_scene : PackedScene:
	set(val):
		suit_track_packed_scene = val
		create_suit_tracks.call_deferred()

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
