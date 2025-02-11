extends Resource

class_name Deck

@export var composition_card_deck_config_array : Array[DeckConfig]

var manager : DebateManager
var draw_pile : Array[Card]

var count : int:
	get:
		return draw_pile.size()

func initialize_deck(manager : DebateManager):
	self.manager = manager
	draw_pile = []
	
	for config in composition_card_deck_config_array:
		for index in config.count:
			var card = Card.new(config.card_data, manager)
			draw_pile.append(card)
	
	draw_pile.shuffle()

func draw_card():
	if draw_pile.size() <= 0:
		return null
	
	return draw_pile.pop_front()

func remove_from_deck(card : Card):
	var cards = composition_card_deck_config_array.map(func(x : DeckConfig): return x.card_data)
	var index = cards.find(card.data)
	
	if index < 0:
		return
	
	composition_card_deck_config_array[index].count -= 1
	if composition_card_deck_config_array[index].count <= 0:
		composition_card_deck_config_array.remove_at(index)

func add_to_deck(card : Card):
	var cards = composition_card_deck_config_array.map(func(x : DeckConfig): return x.card_data)
	var index = cards.find(card.data)
	
	if index < 0:
		composition_card_deck_config_array.append(DeckConfig.new(card.data))
		index = composition_card_deck_config_array.size() - 1
	
	composition_card_deck_config_array[index].count += 1

func remove_from_draw_pile(card : Card):
	var card_data = draw_pile.filter(func(x): return x.card_data)
	var index = card_data.find(card.data)
	
	if index < 0: return
	
	draw_pile.remove_at(index)
	draw_pile.shuffle()

func add_to_draw_pile(card : Card):
	draw_pile.append(card)
	draw_pile.shuffle()
