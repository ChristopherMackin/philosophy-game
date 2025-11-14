extends Node

class_name NodeBasedDebateSubscriber

@export var manager : DebateManager

func _ready():
	manager.subscribe(self)

func on_debate_start():
	pass

func on_turn_start(_contestant: Contestant):
	pass

func on_turn_end(_contestant: Contestant):
	pass

func on_card_played(_card: Card, _contestant : Contestant):
	pass

func on_token_played(_token: Token, _suit: Suit, _contestant : Contestant):
	pass

func on_lines_cleared(_count : int):
	pass

func on_debate_finished():
	pass

func on_actions_invoked(_card : Card, _action_type: CardAction.Type, _contestant : Contestant):
	pass

func on_card_drawn(_card : Card, _contestant: Contestant):
	pass
	
func on_card_hold_updated(_card : Card, _active_contestant : Contestant):
	pass

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		manager.unsubscribe(self)
