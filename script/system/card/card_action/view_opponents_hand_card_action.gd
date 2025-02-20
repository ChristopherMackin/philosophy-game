extends CardAction

class_name ViewOpponentsHandCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var opponent = manager.get_opponent(player)
	
	if player.hand.size() <= 0: return
	
	await player.view(
		opponent.hand,
		"view_opponent_hand"
	)
