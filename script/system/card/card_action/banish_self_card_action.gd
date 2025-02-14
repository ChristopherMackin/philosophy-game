extends CardAction

class_name BanishSelfCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	if player.hand.has(card):
		player.remove_card_from_hand(card)
	await player.remove_from_deck(card)
