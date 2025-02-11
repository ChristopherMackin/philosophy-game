extends CardAction

class_name DiscardTopFromHandCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	if player.hand.size() <= 0:
		return
	
	var selected_card = await player.select(
		player.hand,
		"self_discard",
		true
	)
	
	player.discard_card(selected_card)
