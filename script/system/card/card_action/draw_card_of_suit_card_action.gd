extends CardAction

class_name DrawCardOfSuitCardAction

@export var which_contestant : Constants.WhichContestant
@export var suits : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.WhichContestant.SELF else manager.get_opponent(player)
	
	if suits.size() <= 0:
		suits = manager.debate_settings.suits
	
	var response = await player.select(SelectionRequest.new(
		suits,
		"%s_draw_card_of_suit" % Constants.WhichContestant.keys()[which_contestant],
		"suit"
	))
	
	var index = contestant.draw_pile.map(func(x): return x.suit).find(response.data)
	
	if index < 0:
		return
	
	contestant.draw_at_index(index)
