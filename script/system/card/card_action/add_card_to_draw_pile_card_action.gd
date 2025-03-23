extends CardAction

class_name AddCardToDrawPileCardAction

@export var which_contestant : Const.WhichContestant
@export var base : CardBase
@export var amount : int = 1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	for i in amount:
		contestant.append_to_draw_pile(Card.new(base, manager))
