extends CardAction

class_name DrawCardOfSuitCardAction

@export var suits : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	if suits.size() <= 0:
		suits = manager.debate_settings.suits
	
	var selected_suit = await player.select(
		suits,
		"draw_card_of_suit",
		"suit"
	)
	
	var index = player.draw_pile.map(func(x): return x.suit).find(selected_suit)
	
	if index < 0:
		return
	
	player.draw_at_index(index)
