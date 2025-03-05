extends Node3D

class_name Board

func get_suit_track(token : Token):
	pass

func clear_row(amount : int):
	pass

func update_board(suit_track_dictionary : Dictionary, active_contestant : String):
	pass

func _add_token(token : Token, suit_track : SuitTrack3D, contestant : DebateContestant3D):
	pass

func _remove_token(token : Token, suit_track : SuitTrack3D, contestant : DebateContestant3D):
	pass
