extends Object

class_name Contestant

var character : Character
var hand_card_array : Array = []

var brain : Brain: 
	get: return character.brain
var deck : Deck:
	get: return character.deck
var hand_limit : int:
	get: return character.hand_limit
var name : String:
	get: return character.name

signal on_card_selected(card : Card)

func _init(character : Character):
	self.character = character
	self.character.brain.contestant = self

func take_turn():
	return await brain.think()

func get_card_to_play():	
	var card_to_play = brain.think()
	
	if hand_card_array.has(card_to_play):
		return card_to_play
	else:
		return null

func draw_full_hand():
	var added_cards = []
	
	while hand_card_array.size() < hand_limit:
		var card = deck.draw_card()
		if card == null:
			break
		hand_card_array.append(card)
		added_cards.append(card)

func discard_card(card : Card):
	var index = hand_card_array.find(card)
	hand_card_array.remove_at(index)
	deck.discard_card(card)
	
	if hand_card_array.size() <= 0:
		draw_full_hand()
