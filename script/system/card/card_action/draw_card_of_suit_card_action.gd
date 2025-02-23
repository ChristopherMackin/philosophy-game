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
	
	print(selected_suit.name)

