extends TopAction

class_name DiscardOpponentTopTopAction

func invoke(player : Contestant, manager : DebateManager):
	if manager.get_opponent(player).hand.size() <= 0:
		return
	
	var top = await player.select_top(
		manager.get_opponent(player).hand,
		"enemy_top_removal",
		true
	)
	
	manager.get_opponent(player).discard_top(top)
