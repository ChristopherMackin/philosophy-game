extends CardAction

class_name AddCardToHandCardAction

@export var base : CardBase
@export var amount : int = 1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	for i in amount:
		player.hand.append(Card.new(base, manager))
