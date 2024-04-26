extends Deck

class_name InfiniteDeck

func initialize_deck():
	draw_pile = []
	
	for config in composition_card_deck_config_array:
		for index in config.count:
			var card = Card.new(config.card_data)
			draw_pile.append(card)
	
	draw_pile.shuffle()
	discard_pile = []

func reshuffle():
	draw_pile = discard_pile.duplicate()
	draw_pile.shuffle()
	discard_pile = []

func draw_card():
	if draw_pile.size() <= 0:
		if discard_pile.size() > 0:
			reshuffle()
		else:
			return null
	
	return draw_pile.pop_front()

func discard_card(card : Card):
	discard_pile.append(card)
