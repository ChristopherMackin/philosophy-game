extends TopAction

class_name DiscardTopFromHandTopAction

func invoke(top : Top, player : Contestant, manager : DebateManager):
	if player.hand.size() <= 0:
		return
	
	var selected_top = await player.select_top(
		player.hand,
		"self_discard",
		true
	)
	
	player.discard_top(selected_top)
