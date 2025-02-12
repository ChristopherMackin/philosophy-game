extends Object

class_name Contestant

signal on_hand_updated(contestant)
signal on_energy_updated(contestant)
signal on_deck_updated(contestant)

var manager : DebateManager
var character : Character
var hand : Array[Card] = []

var name : String:
	get: return character.name
var _brain : Brain: 
	get: return character.brain
var _deck : Deck:
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
var blackboard : Blackboard:
	get: return character.blackboard

func _init(character : Character):
	self.character = character
	self.character.brain.contestant = self

func ready_up(manager : DebateManager):
	self.manager = manager
	_deck.initialize_deck(manager)
	draw_full_hand()
	current_energy = energy_limit

func clean_up():
	draw_full_hand()
	current_energy = energy_limit

func draw_full_hand():
	var is_draw_pile_empty = false
	while hand.size() < draw_limit && !is_draw_pile_empty:
		is_draw_pile_empty = !_draw_card()
	on_hand_updated.emit(self)
	on_deck_updated.emit(self)

func draw_number_of_cards(amount : int):
	var is_draw_pile_empty = false
	while amount > 0 && !is_draw_pile_empty:
		is_draw_pile_empty = !_draw_card()
		amount -= 1
	on_hand_updated.emit(self)
	on_deck_updated.emit(self)

func _draw_card() -> bool:
	var card = _deck.draw_card()
	if card == null:
		return false
	
	hand.append(card)
	return true
	
func select(options : Array = hand, what : String = "play", visible_to_player : bool = true):
	var option = await _brain.select(options, what, visible_to_player)
	
	while options.find(option) == -1:
		option = await _brain.select(options, what, visible_to_player)
	
	return option

func remove_card_from_hand(card : Card):
	var index = hand.find(card)
	hand.remove_at(index)
	
	if hand.size() <= 0:
		draw_full_hand()
	
	on_hand_updated.emit(self)
	on_deck_updated.emit(self)

func get_playable_cards() -> Array[Card]:
	return hand.filter(func(x): return x.cost <= current_energy)

func play_card(card : Card, cost_override : int = 0, use_action : bool = true):
	remove_card_from_hand(card)
	
	if(use_action):
		for action in card.data.on_play_card_action:
			await action.invoke(card, self, manager)

func discard_card(card : Card):
	remove_card_from_hand(card)
	
	for action in card.data.on_discard_card_action:
		await action.invoke(card, self, manager)

func remove_from_deck(card : Card):
	_deck.remove_from_deck(card)
	for action in card.data.on_banish_card_action:
		await action.invoke(card, self, manager)

func add_to_deck(card : Card):
	_deck.add_to_deck(card)

func remove_from_draw_pile(card : Card):
	_deck.remove_from_draw_pile(card)

func add_to_draw_pile(card : Card):
	_deck.add_to_draw_pile(card)

func get_deck_count() -> int:
	return _deck.count
