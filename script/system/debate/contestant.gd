extends Object

class_name Contestant

var character : Character
var hand : Array[Card] = []

var name : String:
	get: return character.name
var brain : Brain: 
	get: return character.brain
var deck : Deck:
	get: return character.deck
var hand_limit : int:
	get: return character.hand_limit
var energy_limit : int:
	get: return character.energy_level
var current_energy : int
var debate_event_factory : EventFactory:
	get: return character.debate_event_factory
var memory : StateDatabase:
	get: return character.memory

func _init(character : Character):
	self.character = character
	self.character.brain.contestant = self

func ready_up():
	deck.initialize_deck()
	draw_full_hand()
	current_energy = energy_limit

func take_turn() -> Card:
	var card = await brain.pick_card()
	
	while hand.map(func(x): return x.data).find(card.data) == -1:
		card = await brain.pick_card()
	
	play_card(card)
	current_energy -= 1
	return card

func clean_up():
	draw_full_hand()
	current_energy = energy_limit

func draw_full_hand():
	var added_cards = []
	
	while hand.size() < hand_limit:
		var card = deck.draw_card()
		if card == null:
			break
		hand.append(card)
		added_cards.append(card)

func play_card(card : Card):
	var index = hand.find(card)
	hand.remove_at(index)
	
	if hand.size() <= 0:
		draw_full_hand()
