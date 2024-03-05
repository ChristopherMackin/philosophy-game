@tool
extends Resource

class_name Deck

@export var composition_card_deck_config_array : Array:
	get:
		return composition_card_deck_config_array
	set(value):
		composition_card_deck_config_array.resize(value.size())
		composition_card_deck_config_array = value
		for i in composition_card_deck_config_array.size():
			if not composition_card_deck_config_array[i]:
				var resource = CardDeckConfig.new()
				resource.resource_name = "Card Deck Config"
				composition_card_deck_config_array[i] = resource

var draw_pile_card_array : Array
var discard_pile_card_array : Array

func reset_deck():
	draw_pile_card_array = []
	
	for config in composition_card_deck_config_array:
		for index in config.count:
			var card = Card.new(config.card_data)
			draw_pile_card_array.append(card)
	
	draw_pile_card_array.shuffle()
	discard_pile_card_array = []

func reshuffle():
	draw_pile_card_array = discard_pile_card_array.duplicate()
	draw_pile_card_array.shuffle()
	discard_pile_card_array = []

func draw_card():
	if draw_pile_card_array.size() <= 0:
		reshuffle()
	
	return draw_pile_card_array.pop_front()

func discard_card(card : Card):
	discard_pile_card_array.append(card)
