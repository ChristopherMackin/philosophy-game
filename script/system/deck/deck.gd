extends Resource

class_name Deck

@export var composition_top_deck_config_array : Array[TopsDeckConfig]

var manager : DebateManager
var draw_pile : Array[Top]

var count : int:
	get:
		return draw_pile.size()

func initialize_deck(manager : DebateManager):
	self.manager = manager
	draw_pile = []
	
	for config in composition_top_deck_config_array:
		for index in config.count:
			var top = Top.new(config.top_data, manager)
			draw_pile.append(top)
	
	draw_pile.shuffle()

func draw_top():
	if draw_pile.size() <= 0:
		return null
	
	return draw_pile.pop_front()

func remove_from_deck(top : Top):
	var tops = composition_top_deck_config_array.map(func(x : TopsDeckConfig): return x.top_data)
	var index = tops.find(top.data)
	
	if index < 0:
		return
	
	composition_top_deck_config_array[index].count -= 1
	if composition_top_deck_config_array[index].count <= 0:
		composition_top_deck_config_array.remove_at(index)
