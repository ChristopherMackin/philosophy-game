extends Object

class_name Contestant

signal on_hand_updated(contestant)
signal on_energy_updated(contestant)
signal on_deck_updated(contestant)

var character : Character
var hand : Array[Top] = []

var name : String:
	get: return character.name
var brain : Brain: 
	get: return character.brain
var deck : Deck:
	get: return character.deck
var draw_limit : int:
	get: return character.draw_limit
var hand_limit : int:
	get: return character.hand_limit
var energy_limit : int:
	get: return character.energy_level
var current_energy : int:
	set(val):
		current_energy = val
		on_energy_updated.emit(self)
var debate_event_factory : EventFactory:
	get: return character.debate_event_factory
var memory : StateDatabase:
	get: return character.memory

func _init(character : Character):
	self.character = character
	self.character.brain.contestant = self

func ready_up(manager : DebateManager):
	deck.initialize_deck(manager)
	draw_full_hand()
	current_energy = energy_limit

func take_turn() -> Top:
	var top = await brain.pick_top()
	
	while current_energy < top.data.cost || hand.map(func(x): return x.data).find(top.data) == -1:
		top = await brain.pick_top()
	
	play_top(top)
	current_energy -= top.data.cost
	return top

func clean_up():
	draw_full_hand()
	current_energy = energy_limit

func draw_full_hand():
	var is_draw_pile_empty = false
	while hand.size() < draw_limit && !is_draw_pile_empty:
		is_draw_pile_empty = !_draw_top()
	on_hand_updated.emit(self)
	on_deck_updated.emit(self)

func draw_number_of_tops(amount : int):
	var is_draw_pile_empty = false
	while amount > 0 && !is_draw_pile_empty:
		is_draw_pile_empty = !_draw_top()
		amount -= 1
	on_hand_updated.emit(self)
	on_deck_updated.emit(self)

func _draw_top() -> bool:
	var top = deck.draw_top()
	if top == null:
		return false
	
	hand.append(top)
	return true

func play_top(top : Top):
	var index = hand.find(top)
	hand.remove_at(index)
	
	if hand.size() <= 0:
		draw_full_hand()
	
	on_hand_updated.emit(self)
	on_deck_updated.emit(self)
