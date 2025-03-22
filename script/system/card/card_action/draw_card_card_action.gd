extends CardAction

class_name DrawCardCardAction

@export var which_contestant : Constants.WhichContestant
@export var draw_amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.WhichContestant.SELF else manager.get_opponent(player)
	await contestant.draw_number_of_cards(draw_amount)
