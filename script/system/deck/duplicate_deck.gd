extends Deck

class_name DuplicateDeck

@export var number_of_duplications : int = 10

func create_draw_pile(manager : DebateManager):
	self.manager = manager
	var pile_to_duplicate = []
	
	for config in composition_card_deck_config_array:
		for index in config.count:
			var card = Card.new(config.base, manager)
			pile_to_duplicate.append(card)
	
	var draw_pile = []
	
	for i in number_of_duplications:
		var append = pile_to_duplicate.duplicate(true)
		append.shuffle()
		draw_pile.append_array(append)
	
	return draw_pile
