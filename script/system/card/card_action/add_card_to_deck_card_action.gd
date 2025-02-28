extends CardAction

class_name AddCardToDeckCardAction

@export var which_contestant : Constants.Contestant
@export var base : CardBase
@export var amount : int = 1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	
	for i in amount:
		contestant.add_to_deck(Card.new(base, manager))
