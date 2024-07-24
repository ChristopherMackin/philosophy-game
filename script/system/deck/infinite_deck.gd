extends Deck

class_name InfiniteDeck

func draw_top():
	if draw_pile.size() <= 0:
		initialize_deck()
	
	return draw_pile.pop_front()
