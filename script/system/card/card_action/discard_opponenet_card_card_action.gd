extends CardAction

class_name DiscardOpponentTopCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var opponent = manager.get_opponent(player)
	
	if opponent.hand.size() <= 0:
		return
	
	var selected_card = await player.select(
		opponent.hand,
		"opponent_card_removal",
		true
	)
	
	opponent.discard_card(selected_card)
