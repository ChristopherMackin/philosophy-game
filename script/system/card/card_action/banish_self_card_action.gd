extends CardAction

class_name BanishSelfCardAction

func invoke(card : Card, player : Contestant, manager : DebateManager):
	player.remove_from_deck(card)
