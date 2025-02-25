extends CardAction

class_name GiveCardToOpponentCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	if player.hand.size() <= 0: return
	
	var response = await player.select(SelectionRequest.new(
		player.hand,
		"give_card_to_opponent"
	))
	
	player.remove_card_from_hand(response.data)
	manager.get_opponent(player).add_card_to_hand(response.data)
