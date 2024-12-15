extends Node

class_name DebateSubscriber
@export var manager : DebateManager

func _ready():
	manager.subscribe(self)

func on_debate_start():
	pass
	
func on_player_change(contestant : Contestant):
	pass
	
func on_top_played(top: Top, active_contestant : Contestant):
	pass

func on_score_updated(pose_score_dictionary : Dictionary):
	pass

func on_lines_cleared(count : int):
	pass

func on_debate_finished():
	pass

func on_hand_updated(contestant : Contestant):
	pass

func on_energy_updated(contestant : Contestant):
	pass

func on_deck_updated(contestant : Contestant):
	pass
