extends Deck

class_name InfiniteDeck

func create_draw_pile(manager : DebateManager):
	self.manager = manager
	var draw_pile = []
	
	for config in composition_card_deck_config_array:
		for index in config.count:
			var card = Card.new(config.base, manager)
			draw_pile.append(card)
	
	draw_pile.shuffle()
	
	return draw_pile
