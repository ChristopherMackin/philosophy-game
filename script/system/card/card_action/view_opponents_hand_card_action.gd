extends CardAction

class_name ViewOpponentsHandCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var opponent = manager.get_opponent(player)
	
	if player.hand.size() <= 0: return
	
	await player.select(SelectionRequest.new(
		opponent.hand,
		"view_opponent_hand",
		Const.WhichContestant.OPPONENT,
		Const.SelectionAction.VIEW
	))
