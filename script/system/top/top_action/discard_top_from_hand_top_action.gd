extends TopAction

class_name DiscardTopFromHandTopAction

func invoke(player : Contestant, manager : DebateManager):
	if player.hand.size() <= 0:
		return
	
	var top = await player.select_top(
		player.hand,
		"self_discard",
		true
	)
	
	player.discard_top(top)
