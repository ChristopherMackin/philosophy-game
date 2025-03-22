extends CardAction

class_name DrawCardOfSuitCardAction

@export var which_contestant : Const.WhichContestant
@export var suits : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	if suits.size() <= 0:
		suits = manager.debate_settings.suits
	
	var response = await player.select(SelectionRequest.new(
		suits,
		"draw_card_of_suit",
		which_contestant,
		Const.SelectionAction.SINGLE,
		Const.SelectionType.SUIT
	))
	
	var index = contestant.draw_pile.map(func(x): return x.suit).find(response.data)
	
	if index < 0:
		return
	
	contestant.draw_at_index(index)
