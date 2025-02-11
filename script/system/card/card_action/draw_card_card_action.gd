extends CardAction

class_name DrawCardCardAction

@export var draw_amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	player.draw_number_of_cards(draw_amount)
