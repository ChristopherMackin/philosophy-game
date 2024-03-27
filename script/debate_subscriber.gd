extends Node

class_name DebateSubscriber
@export var manager : DebateManager

func _ready():
	manager.subscribe(self)

func on_debate_start():
	pass
	
func on_player_change(contestnat : Contestant):
	pass
	
func on_card_played(previous_card : Card, follow_up_card : Card, active_contestant : Contestant):
	pass

func on_action_taken(type : DebateManager.CardActions):
	pass
