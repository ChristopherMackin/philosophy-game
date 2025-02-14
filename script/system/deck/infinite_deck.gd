extends Deck

class_name InfiniteDeck

func draw_card():
	if _draw_pile.size() <= 0:
		initialize_deck(manager)
	
	return _draw_pile.pop_front()

func get_draw_pile_count():
	return 1000000000
