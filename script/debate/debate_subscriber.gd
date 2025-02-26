extends Node

class_name DebateSubscriber
@export var manager : DebateManager

func _ready():
	manager.subscribe(self)

func on_debate_start():
	pass
	
func on_player_change(_contestant : Contestant):
	pass
	
func on_card_played(_card: Card, _active_contestant : Contestant):
	pass

func on_card_hold_updated(_card : Card, _active_contestant : Contestant):
	pass

func on_lines_cleared(_count : int):
	pass

func on_suit_track_updated(_suit_track_dictionary : Dictionary):
	pass

func on_debate_finished():
	pass

func on_hand_updated(_contestant : Contestant):
	pass

func on_energy_updated(_contestant : Contestant):
	pass

func on_draw_pile_updated(_contestant : Contestant):
	pass
