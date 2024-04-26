extends Resource

class_name Deck

@export var composition_card_deck_config_array : Array[CardDeckConfig]

var draw_pile : Array[Card]

var count : int:
	get:
		return draw_pile.size()

func initialize_deck():
	draw_pile = []
	
	for config in composition_card_deck_config_array:
		for index in config.count:
			var card = Card.new(config.card_data)
			draw_pile.append(card)
	
	draw_pile.shuffle()

func draw_card():
	if draw_pile.size() <= 0:
		return null
	
	return draw_pile.pop_front()
