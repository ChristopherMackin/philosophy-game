extends Node

class_name DebateSubscriber
@export var manager : DebateManager

func _ready():
	manager.subscribe(self)

func on_debate_start():
	pass
	
func on_player_change(_contestant : Contestant):
	pass
	
func on_top_played(_top: Top, _active_contestant : Contestant):
	pass

func on_score_updated(_pose_score_dictionary : Dictionary):
	pass

func on_lines_cleared(_count : int):
	pass

func on_debate_finished():
	pass

func on_hand_updated(_contestant : Contestant):
	pass

func on_energy_updated(_contestant : Contestant):
	pass

func on_deck_updated(_contestant : Contestant):
	pass
