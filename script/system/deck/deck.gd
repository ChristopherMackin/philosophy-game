extends Resource

class_name Deck

@export var composition_top_deck_config_array : Array[TopDeckConfig]

var draw_pile : Array[Top]

var count : int:
	get:
		return draw_pile.size()

func initialize_deck():
	draw_pile = []
	
	for config in composition_top_deck_config_array:
		for index in config.count:
			var top = Top.new(config.top_data)
			draw_pile.append(top)
	
	draw_pile.shuffle()

func draw_top():
	if draw_pile.size() <= 0:
		return null
	
	return draw_pile.pop_front()
