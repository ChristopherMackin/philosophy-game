extends CardAction

class_name AddCardToDeckCardAction

@export var card_data : CardData
@export var amount : int = 1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	for i in amount:
		player.add_to_deck(Card.new(card_data, manager))
