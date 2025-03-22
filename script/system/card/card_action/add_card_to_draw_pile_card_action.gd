extends CardAction

class_name AddCardToDrawPileCardAction

@export var which_contestant : Constants.WhichContestant
@export var base : CardBase
@export var amount : int = 1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.WhichContestant.SELF else manager.get_opponent(player)
	
	for i in amount:
		contestant.add_to_draw_pile(Card.new(base, manager))
