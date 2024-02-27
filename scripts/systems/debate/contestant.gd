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

signal on_hand_update(contestant : Contestant, hand_card_array : Array)

func _init(character : Character):
	self.character = character
	self.character.brain.contestant = self

func ready_up():
	deck.reset_deck()
	draw_full_hand()

func take_turn():
	var card = await brain.think()
	discard_card(card)
	return card

func draw_full_hand():
	var added_cards = []
	
	while hand_card_array.size() < hand_limit:
		var card = deck.draw_card()
		if card == null:
			break
		hand_card_array.append(card)
		added_cards.append(card)
	
	print("%s drew full hand" % character.name)
	on_hand_update.emit(self, hand_card_array)

func discard_card(card : Card):
	var index = hand_card_array.find(card)
	hand_card_array.remove_at(index)
	deck.discard_card(card)
	
	print("%s discarded card" % character.name)
	on_hand_update.emit(self, hand_card_array)
	
	print(hand_card_array.size())
	
	if hand_card_array.size() <= 0:
		draw_full_hand()
