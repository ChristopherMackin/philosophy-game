extends Object

class_name Contestant

var character : Character
var hand : Array[Top] = []

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

func take_turn() -> Top:
	var top = await brain.pick_top()
	
	while hand.map(func(x): return x.data).find(top.data) == -1:
		top = await brain.pick_top()
	
	play_top(top)
	current_energy -= 1
	return top

func clean_up():
	draw_full_hand()
	current_energy = energy_limit

func draw_full_hand():
	var added_tops = []
	
	while hand.size() < hand_limit:
		var top = deck.draw_top()
		if top == null:
			break
		hand.append(top)
		added_tops.append(top)

func play_top(top : Top):
	var index = hand.find(top)
	hand.remove_at(index)
	
	if hand.size() <= 0:
		draw_full_hand()
