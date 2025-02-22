extends Resource

class_name Deck

@export var composition_card_deck_config_array : Array[DeckConfig]

var manager : DebateManager
var _draw_pile : Array[Card]

func get_draw_pile_count() -> int:
	return _draw_pile.size()

func initialize_deck(manager : DebateManager):
	self.manager = manager
	_draw_pile = []
	
	for config in composition_card_deck_config_array:
		for index in config.count:
			var card = Card.new(config.base, manager)
			_draw_pile.append(card)
	
	_draw_pile.shuffle()

func draw_card():
	if _draw_pile.size() <= 0:
		return null
	
	return _draw_pile.pop_front()

func remove_from_deck(card : Card):
	var cards = composition_card_deck_config_array.map(func(x : DeckConfig): return x.base)
	var index = cards.find(card.data)
	
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

func remove_from_draw_pile(card : Card):
	var card_bases = _draw_pile.filter(func(x): return x.base)
	var index = card_bases.find(card.base)
	
	if index < 0: return
	
	_draw_pile.remove_at(index)
	_draw_pile.shuffle()

func add_to_draw_pile(card : Card):
	_draw_pile.append(card)
	_draw_pile.shuffle()
