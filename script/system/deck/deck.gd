extends Resource

class_name Deck

@export var composition_card_deck_config_array : Array[DeckConfig]

var manager : DebateManager

func create_draw_pile(manager : DebateManager) -> Array[Card]:
	self.manager = manager
	var draw_pile : Array[Card] = []
	
	for config in composition_card_deck_config_array:
		for index in config.count:
			var card = Card.new(config.base, manager)
			draw_pile.push_back(card)
	
	draw_pile.shuffle()
	
	return draw_pile

func remove_from_deck(card : Card):
	var cards = composition_card_deck_config_array.map(func(x : DeckConfig): return x.base)
	var index = cards.find(card._base)
	
	if index < 0:
		return
	
	composition_card_deck_config_array[index].count -= 1
	if composition_card_deck_config_array[index].count <= 0:
		composition_card_deck_config_array.remove_at(index)

func add_to_deck(card : Card):
	var cards = composition_card_deck_config_array.map(func(x : DeckConfig): return x.base)
	var index = cards.find(card.data)
	
	if index < 0:
		composition_card_deck_config_array.append(DeckConfig.new(card.data))
		index = composition_card_deck_config_array.size() - 1
	
	composition_card_deck_config_array[index].count += 1
