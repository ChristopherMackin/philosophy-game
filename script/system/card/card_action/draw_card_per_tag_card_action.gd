extends CardAction

class_name DrawCardPerTagCardAction

@export var tag : Constants.Tag
@export var tag_per_card : float

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var tag_count = 0
	for key in manager.suit_track_dictionary:
		tag_count += manager.suit_track_dictionary[key]\
		.filter(func(x): return x.tag == tag).size()
	
	var draw_amount = floor(tag_count / tag_per_card)
	
	await player.draw_number_of_cards(draw_amount)

