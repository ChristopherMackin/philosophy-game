extends CardAction

class_name AddCardToHandCardAction

@export var card_data : CardData
@export var amount : int = 1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	for i in amount:
		player.hand.append(Card.new(card_data, manager))
