extends CardAction

class_name DiscardOpponentTopCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	if manager.get_opponent(player).hand.size() <= 0:
		return
	
	var selected_card = await player.select(
		manager.get_opponent(player).hand,
		"opponent_card_removal",
		true
	)
	
	manager.get_opponent(player).discard_card(selected_card)
