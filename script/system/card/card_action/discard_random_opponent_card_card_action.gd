extends CardAction

class_name  DiscardRandomOpponentTopCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var opponent = manager.get_opponent(player)
	
	if(opponent.hand.size() < 0):
		return
	
	var i := randi_range(0, opponent.hand.size() - 1)
	opponent.discard_card(opponent.hand[i])
