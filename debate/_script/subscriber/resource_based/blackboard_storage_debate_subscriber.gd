extends ResourceBasedDebateSubscriber

class_name BlackboardStorageDebateSubscriber

var blackboard: Blackboard: 
	get: return manager.blackboard

func on_debate_start():
	manager.blackboard.expire(Blackboard.ExpirationToken.ON_DEBATE_START)
	
	blackboard.add_flag(Flag.PLAYER, manager.player, Blackboard.ExpirationToken.ON_DEBATE_START)
	blackboard.add_flag(Flag.COMPUTER, manager.computer, Blackboard.ExpirationToken.ON_DEBATE_START)
	blackboard.add_flag(Flag.CURRENT_TURN, manager.current_turn, Blackboard.ExpirationToken.ON_DEBATE_START)
	blackboard.add_flag(Flag.CURRENT_ROUND, manager.current_round, Blackboard.ExpirationToken.ON_DEBATE_START)

func on_turn_start(contestant: Contestant):
	manager.blackboard.expire(Blackboard.ExpirationToken.ON_TURN_START)
	
	blackboard.add_flag(Flag.CURRENT_TURN, manager.current_turn, Blackboard.ExpirationToken.ON_DEBATE_START)
	blackboard.add_flag(Flag.CURRENT_ROUND, manager.current_round, Blackboard.ExpirationToken.ON_DEBATE_START)
	
	var which_contestant = "player" if contestant == manager.player else "computer"
	blackboard.add_flag(Flag.ACTIVE_CONTESTANT, which_contestant, Blackboard.ExpirationToken.ON_DEBATE_START)
	
	blackboard.add_flag(Flag.TURN_CARD_HISTORY, [], Blackboard.ExpirationToken.ON_TURN_START)
	blackboard.add_flag(Flag.TURN_TOKEN_HISTORY, [], Blackboard.ExpirationToken.ON_TURN_START)
	blackboard.add_flag(Flag.CARDS_PLAYED_THIS_TURN, 0, Blackboard.ExpirationToken.ON_TURN_START)
	blackboard.add_flag(Flag.TOKENS_PLAYED_THIS_TURN, 0, Blackboard.ExpirationToken.ON_TURN_START)

func on_turn_end(_contestant: Contestant):
	manager.blackboard.expire(Blackboard.ExpirationToken.ON_TURN_END)
	pass

func on_card_played(card: Card, _contestant : Contestant):
	#Update Card History
	if !blackboard.has_flag(Flag.CARD_HISTORY): blackboard.add_flag(Flag.CARD_HISTORY, [], Blackboard.ExpirationToken.ON_DEBATE_START)
	var history = blackboard.get_flag_value(Flag.CARD_HISTORY)
	history.push_front(card)
	blackboard.add_flag(Flag.CARD_HISTORY, history, Blackboard.ExpirationToken.ON_DEBATE_START)
	
	#Update Turn Card History
	var turn_history = blackboard.get_flag_value(Flag.TURN_CARD_HISTORY)
	turn_history.push_front(card)
	blackboard.add_flag(Flag.TURN_CARD_HISTORY, turn_history, Blackboard.ExpirationToken.ON_TURN_START)
	
	blackboard.add_flag(Flag.CARDS_PLAYED_THIS_TURN, turn_history.size(), Blackboard.ExpirationToken.ON_TURN_START)
	
	#Update Current Suit
	blackboard.add_flag(Flag.CURRENT_SUIT, card.suit, Blackboard.ExpirationToken.ON_DEBATE_START)

func on_token_played(token: Token, _suit: Suit, _contestant : Contestant):
	#Update Token History
	if !blackboard.has_flag(Flag.TOKEN_HISTORY): blackboard.add_flag(Flag.TOKEN_HISTORY, [], Blackboard.ExpirationToken.ON_DEBATE_START)
	var history = blackboard.get_flag_value(Flag.TOKEN_HISTORY)
	history.push_front(token)
	blackboard.add_flag(Flag.TOKEN_HISTORY, history, Blackboard.ExpirationToken.ON_DEBATE_START)
	
	#Update Turn Token History
	var turn_history = blackboard.get_flag_value(Flag.TURN_TOKEN_HISTORY)
	turn_history.push_front(token)
	blackboard.add_flag(Flag.TURN_TOKEN_HISTORY, turn_history, Blackboard.ExpirationToken.ON_TURN_START)
	
	blackboard.add_flag(Flag.TOKENS_PLAYED_THIS_TURN, turn_history.size(), Blackboard.ExpirationToken.ON_TURN_START)

func on_lines_cleared(count : int):
	blackboard.add_flag(Flag.LINES_CLEARED, manager.lines_cleared, Blackboard.ExpirationToken.ON_DEBATE_START)

func on_debate_finished():
	if !manager.player.character.can_recall_flag(Flag.DEBATES_FINISHED):
		manager.player.character.remember_flag(Flag.DEBATES_FINISHED, 1)
	else:
		var debates_finished = manager.player.character.recall_flag(Flag.DEBATES_FINISHED)
		manager.player.character.remember_flag(Flag.DEBATES_FINISHED, debates_finished + 1)
	
	if !manager.computer.character.can_recall_flag(Flag.DEBATES_FINISHED):
		manager.computer.character.remember_flag(Flag.DEBATES_FINISHED, 1)
	else:
		var debates_finished = manager.computer.character.recall_flag(Flag.DEBATES_FINISHED)
		manager.computer.character.remember_flag(Flag.DEBATES_FINISHED, debates_finished + 1)

func on_actions_invoked(_card : Card, _action_type: CardAction.Type, _contestant : Contestant):
	manager.blackboard.expire(Blackboard.ExpirationToken.ON_ACTION_END)
	pass

func on_card_drawn(_card : Card, _contestant: Contestant):
	pass

func on_card_hold_updated(_card : Card, _active_contestant : Contestant):
	pass
