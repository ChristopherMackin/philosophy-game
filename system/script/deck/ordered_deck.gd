@tool
extends Deck

class_name OrderedDeck

func create_draw_pile(manager : DebateManager) -> CardCollection:
	self.manager = manager
	var draw_pile : Array[Card] = []
	
	for config in composition_card_deck_config_array:
		for index in config.count:
			var card = Card.new(config.base, manager)
			draw_pile.push_back(card)
	
	return CardCollection.new(draw_pile)
