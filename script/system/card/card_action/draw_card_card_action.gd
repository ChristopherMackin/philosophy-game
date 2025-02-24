extends CardAction

class_name DrawCardCardAction

@export var which_contestant : Constants.Contestant
@export var draw_amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	contestant.draw_number_of_cards(draw_amount)
