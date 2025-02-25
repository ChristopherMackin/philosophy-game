extends Deck

class_name DuplicateDeck

@export var number_of_duplications : int = 10

func create_draw_pile(manager : DebateManager):
	self.manager = manager
	var draw_pile = []
	
	for i in number_of_duplications:
		for config in composition_card_deck_config_array:
			var pile_to_append = []
			for index in config.count:
				var card = Card.new(config.base, manager)
				pile_to_append.append(card)
			draw_pile.append_array(pile_to_append)
	
	return draw_pile
