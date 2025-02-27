extends Object

class_name Contestant

signal on_hand_updated(contestant)
signal on_energy_updated(contestant)
signal on_draw_pile_updated(contestant)
signal on_card_hold_updated(card, contestant)

var manager : DebateManager
var character : Character
var hand : Array[Card] = []
var draw_pile : Array[Card] = []
var discard_pile : Array[Card] = []
var held_card : Card:
	set(val):
		held_card = val
		on_card_hold_updated.emit(held_card, self)
var can_hold : bool = true

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
	draw_pile.assign(_deck.create_draw_pile(manager))
	draw_full_hand()
	current_energy = energy_limit

func clean_up():
	for card in hand:
		for modifier : CardCostModifier in card.cost_modifiers.filter(func(x): return x.can_expire).duplicate():
			modifier.turn_lifetime -= 1
			if modifier.turn_lifetime <= 0:
				var index = card.cost_modifiers.find(modifier)
				card.cost_modifiers.remove_at(index)
	
	draw_full_hand()
	current_energy = energy_limit
	can_hold = true

func draw_at_index(index : int) -> bool:
	if index < 0 || index >= draw_pile.size():
		return false
	
	hand.append(draw_pile[index])
	draw_pile.remove_at(index)
	
	on_hand_updated.emit(self)
	on_draw_pile_updated.emit(self)
	
	return true

func draw_full_hand():
	var is_draw_pile_empty = false
	while hand.size() < draw_limit && !is_draw_pile_empty:
		is_draw_pile_empty = !_draw_card()
	on_hand_updated.emit(self)
	on_draw_pile_updated.emit(self)

func draw_number_of_cards(amount : int):
	var is_draw_pile_empty = false
	while amount > 0 && !is_draw_pile_empty:
		is_draw_pile_empty = !_draw_card()
		amount -= 1
	on_hand_updated.emit(self)
	on_draw_pile_updated.emit(self)

func _draw_card() -> bool:
	if draw_pile.size() <= 0:
		return false
	
	hand.append(draw_pile.pop_front())
	return true
	
func select(request : SelectionRequest) -> SelectionResponse:
	var is_valid_selection : bool = false
	return await _brain.select(request)

func view(options : Array, what : String = "view", type : String = "card"):
	await _brain.view(options, what, type)

func hold_card(card : Card) -> Card:
	if !can_hold:
		return card
	
	var old_card = held_card
	
	if old_card:
		for action : CardAction in old_card.on_hold_end_card_actions:
			await action.invoke(old_card, self, manager)
	
	held_card = card
	
	if held_card:
		for action : CardAction in held_card.on_hold_start_card_actions:
			await action.invoke(held_card, self, manager)
	
	can_hold = false

	return old_card

func remove_card_from_hand(card : Card):
	var index = hand.find(card)
	hand.remove_at(index)
	
	if hand.size() <= 0:
		draw_full_hand()
	
	on_hand_updated.emit(self)
	on_draw_pile_updated.emit(self)

func get_playable_cards() -> Array[Card]:
	return hand.filter(func(x): return x.cost <= current_energy)

func play_card_from_hand(card : Card):
	remove_card_from_hand(card)
	await play_card(card)

func play_card(card : Card):
	await manager.play_card(card, self)

func discard_card(card : Card):
	discard_pile.append(card)
	for action in card.on_discard_card_actions:
		await action.invoke(card, self, manager)

func discard_card_from_hand(card : Card):
	remove_card_from_hand(card)
	await discard_card(card)

func remove_from_deck(card : Card):
	_deck.remove_from_deck(card)
	for action in card.on_banish_card_actions:
		await action.invoke(card, self, manager)

func add_to_deck(card : Card):
	_deck.add_to_deck(card)

func add_to_draw_pile(card : Card):
	draw_pile.append(card)
	draw_pile.shuffle()

func remove_from_draw_pile(card : Card):
	var card_bases = draw_pile.filter(func(x): return x.base)
	var index = card_bases.find(card.base)
	
	if index < 0: return
	
	draw_pile.remove_at(index)
	draw_pile.shuffle()

func add_card_to_hand(card : Card, index: int = -1):
	if index == -1 || index >= hand.size():
		hand.append(card)
	else:
		hand.insert(index, card)
	
	on_hand_updated.emit(self)
