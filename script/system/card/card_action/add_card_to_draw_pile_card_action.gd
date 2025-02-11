extends CardAction

class_name AddTopToDrawPileCardAction

@export var card_data : CardData
@export var amount : int = 1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	for i in amount:
		player.add_to_draw_pile(Card.new(card_data, manager))
