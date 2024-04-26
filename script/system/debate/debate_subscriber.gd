extends Node

class_name DebateSubscriber
@export var manager : DebateManager

func _ready():
	manager.subscribe(self)

func on_debate_start(starting_card : Card):
	pass
	
func on_player_change(contestant : Contestant):
	pass
	
func on_card_played(card: Card, active_contestant : Contestant):
	pass

func on_action_taken(action : CardAction, is_positive : bool):
	pass

func on_debate_finished():
	pass

func topic_score_updated(topic : Topic, score : int):
	pass
