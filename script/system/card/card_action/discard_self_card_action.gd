extends CardAction

class_name DiscardSelfCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	if player.hand.has(card):
		player.remove_from_hand(card)
	
	player.discard_card(card)
