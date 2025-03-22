extends CardAction

class_name DrawCardCardAction

@export var which_contestant : Constants.WhichContestant
@export var draw_amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Constants.GetContestant(player, manager.get_opponent(player), which_contestant)
	await contestant.draw_number_of_cards(draw_amount)
