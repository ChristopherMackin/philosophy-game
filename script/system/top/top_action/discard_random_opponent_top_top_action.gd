extends TopAction

class_name  DiscardRandomOpponentTopTopAction

func invoke(player : Contestant, manager : DebateManager):
	var opponent = manager.get_opponent(player)
	
	if(opponent.hand.size() < 0):
		return
	
	var i := randi_range(0, opponent.hand.size() - 1)
	opponent.remove_top_from_hand(opponent.hand[i])
