extends Node

class_name DebateSubscriber
@export var manager : DebateManager

func _ready():
	manager.subscribe(self)

func on_debate_start():
	pass
	
func on_player_change(_contestant : Contestant):
	pass
	
func on_card_played(_card: Card, _contestant : Contestant):
	pass

func on_token_played(_token: Token, _parent: Card, _contestant : Contestant):
	pass

func on_card_held(_card : Card, _contestant : Contestant):
	pass

func on_lines_cleared(_count : int):
	pass

func on_debate_finished():
	pass

func on_action_invoked(_action : CardAction, _card : Card, _contestant : Contestant):
	pass
