extends CardAction

class_name DrawCardOfSuitCardAction

@export var which_contestant : Constants.Contestant
@export var suits : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	
	if suits.size() <= 0:
		suits = manager.debate_settings.suits
	
	var selected_suit = await player.select(
		suits,
		"%s_draw_card_of_suit" % Constants.Contestant.keys()[which_contestant],
		"suit"
	)
	
	var index = contestant.draw_pile.map(func(x): return x.suit).find(selected_suit)
	
	if index < 0:
		return
	
	contestant.draw_at_index(index)
