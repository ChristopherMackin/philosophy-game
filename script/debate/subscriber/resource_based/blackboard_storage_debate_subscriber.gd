extends ResourceBasedDebateSubscriber

class_name BlackboardStorageDebateSubscriber

var blackboard: Blackboard: 
	get: return manager.blackboard

func on_debate_start():
	blackboard.add("player", manager.player, Blackboard.ExpirationToken.ON_DEBATE_START)
	blackboard.add("computer", manager.computer, Blackboard.ExpirationToken.ON_DEBATE_START)

func on_turn_start(contestant: Contestant):
	var which_contestant = "player" if contestant == manager.player else "computer"
	blackboard.add("active_contestant", which_contestant, Blackboard.ExpirationToken.ON_DEBATE_START)
	
	blackboard.add("turn_card_history", [], Blackboard.ExpirationToken.ON_DEBATE_START)
	blackboard.add("turn_token_history", [], Blackboard.ExpirationToken.ON_DEBATE_START)

func on_turn_end(contestant: Contestant):
	blackboard.add("current_turn", manager.current_turn, Blackboard.ExpirationToken.ON_DEBATE_START)
	blackboard.add("current_round", manager.current_round, Blackboard.ExpirationToken.ON_DEBATE_START)

func on_card_played(card: Card, contestant : Contestant):
	#Update Card History
	if !blackboard.has("card_history"): blackboard.add("card_history", [], Blackboard.ExpirationToken.ON_DEBATE_START)
	var history = blackboard.get_value("card_history")
	history.push_front(card)
	blackboard.add("card_history", history, Blackboard.ExpirationToken.ON_DEBATE_START)
	
	#Update Turn Card History
	var turn_history = blackboard.get_value("turn_card_history")
	turn_history.push_front(card)
	blackboard.add("turn_card_history", turn_history, Blackboard.ExpirationToken.ON_DEBATE_START)

func on_token_played(token: Token, _suit: Suit, _contestant : Contestant):
	#Update Token History
	if !blackboard.has("token_history"): blackboard.add("token_history", [], Blackboard.ExpirationToken.ON_DEBATE_START)
	var history = blackboard.get_value("token_history")
	history.push_front(token)
	blackboard.add("token_history", history, Blackboard.ExpirationToken.ON_DEBATE_START)
	
	#Update Turn Token History
	var turn_history = blackboard.get_value("turn_token_history")
	turn_history.push_front(token)
	blackboard.add("turn_token_history", turn_history, Blackboard.ExpirationToken.ON_DEBATE_START)

func on_lines_cleared(_count : int):
	blackboard.add("lines_cleared", manager.lines_cleared, Blackboard.ExpirationToken.ON_DEBATE_START)

func on_debate_finished():
	if !manager.player.character.can_recall("debates_finished"):
		manager.player.character.remember("debates_finished", 1)
	else:
		var debates_finished = manager.player.character.recall("debates_finished")
		manager.player.character.remember("debates_finished", debates_finished + 1)
	
	if !manager.computer.character.can_recall("debates_finished"):
		manager.computer.character.remember("debates_finished", 1)
	else:
		var debates_finished = manager.computer.character.recall("debates_finished")
		manager.computer.character.remember("debates_finished", debates_finished + 1)

func on_actions_invoked(_card : Card, _action_type: CardAction.Type, _contestant : Contestant):
	pass
	#Isn't being called at all

func on_card_drawn(_card : Card, _contestant: Contestant):
	pass

func on_card_hold_updated(_card : Card, _active_contestant : Contestant):
	pass
