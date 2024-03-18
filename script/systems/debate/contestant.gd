extends Object

class_name Contestant

var character : Character
var hand : Array[Card] = []

var brain : Brain: 
	get: return character.brain
var deck : Deck:
	get: return character.deck
var hand_limit : int:
	get: return character.hand_limit
var name : String:
	get: return character.name

signal on_hand_update(contestant : Contestant, hand : Array[Card])

func _init(character : Character):
	self.character = character
	self.character.brain.contestant = self

func ready_up():
	deck.reset_deck()
	draw_full_hand()

func take_turn():
	var card
	
	while hand.find(card) == -1:
		card = await brain.think()
	
	discard_card(card)
	return card

func draw_full_hand():
	var added_cards = []
	
	while hand.size() < hand_limit:
		var card = deck.draw_card()
		if card == null:
			break
		hand.append(card)
		added_cards.append(card)
	
	on_hand_update.emit(self, hand.duplicate(true))

func discard_card(card : Card):
	var index = hand.find(card)
	hand.remove_at(index)
	deck.discard_card(card)
	
	on_hand_update.emit(self, hand.duplicate(true))
	
	if hand.size() <= 0:
		draw_full_hand()
