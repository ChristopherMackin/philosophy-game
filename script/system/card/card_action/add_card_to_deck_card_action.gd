extends CardAction

class_name AddCardToDeckCardAction

@export var base : CardBase
@export var amount : int = 1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	for i in amount:
		player.add_to_deck(Card.new(base, manager))
