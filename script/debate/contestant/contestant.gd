extends Object

class_name Contestant

var manager : DebateManager
var character : Character
var hand : Array[Card] = []
var draw_pile : Array[Card] = []
var discard_pile : Array[Card] = []
var playable_cards : Array[Card]:
	get: return hand.filter(func(x): return x.cost <= current_energy)
var held_card : Card
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
var energy_level : int:
	get: return character.energy_level
var current_energy : int:
	get: return current_energy
	set(val):
		current_energy = val if val >= 0 else 0
var debate_event_factory : EventFactory:
	get: return character.debate_event_factory
var blackboard : Blackboard:
	get: return character.blackboard

var can_play:
	get: return current_energy > 0 && playable_cards.size() > 0

func character_is(character : Character):
	return self.character == character

func _init(character : Character):
	self.character = character
	self.character.brain.contestant = self

func ready_up(manager : DebateManager):
	self.manager = manager
	draw_pile.assign(_deck.create_draw_pile(manager))
	await draw_full_hand()
	current_energy = energy_level

func _draw_card() -> bool:
	if draw_pile.size() <= 0:
		return false
	
	var card = draw_pile.pop_front()
	card.generate_token()
	
	hand.append(card)
	
	for sub : DebateSubscriber in manager.subscriber_array: await sub.on_card_drawn(card, self)
	
	return true

func draw_specified_card(card : Card) -> bool:
	var index = draw_pile.find(card)
	if index < 0: return false
	
	var found_card = draw_pile.pop_at(index)
	
	found_card.generate_token()
	
	hand.append(found_card)
	
	for sub : DebateSubscriber in manager.subscriber_array: await sub.on_card_drawn(found_card, self)
	
	return true

func draw_at_index(index : int) -> bool:
	if index < 0 || index >= draw_pile.size():
		return false
	
	var card = draw_pile[index]
	card.generate_token()
	
	hand.append(card)
	draw_pile.remove_at(index)
	
	return true

func draw_number_of_cards(amount : int):
	var is_draw_pile_empty = false
	while amount > 0 && !is_draw_pile_empty:
		is_draw_pile_empty = !await _draw_card()
		amount -= 1

func draw_full_hand():
	var is_draw_pile_empty = false
	while hand.size() < draw_limit && !is_draw_pile_empty:
		is_draw_pile_empty = !await _draw_card()

func start_turn():
	for card : Card in hand.duplicate():
		card.on_turn_start(self, manager)

func end_turn():
	for card : Card in hand.duplicate():
		card.on_turn_end(self, manager)
	
	if held_card:
		held_card.on_hold_stay(self, manager)
	
	for card in hand:
		for modifier : CardCostModifier in card.cost_modifiers.filter(func(x): return x.can_expire).duplicate():
			modifier.turn_lifetime -= 1
			if modifier.turn_lifetime <= 0:
				var index = card.cost_modifiers.find(modifier)
				card.cost_modifiers.remove_at(index)
	
	await draw_full_hand()
	current_energy = energy_level
	can_hold = true

func take_turn() -> SelectionResponse:
	if hand.size() <= 0:
		await draw_full_hand()
	
	var valid_response := false
	var response = null
	
	while(!valid_response):
		response = await select(SelectionRequest.new(hand))
		valid_response = true
		var card = response.data
		
		match response.what:
			"play":
				if playable_cards.has(card):
					remove_from_hand(card)
				else: valid_response = false
			"hold":
				if can_hold:
					hold_card(card)
				else: valid_response = false
				
	return response

func select(request : SelectionRequest) -> SelectionResponse:
	var is_valid_selection : bool = false
	return await _brain.select(request)

func hold_card(card : Card):
	if held_card:
		var index = hand.find(card)
		add_to_hand(held_card, index)
		held_card.on_hold_end(self, manager)
	
	if card:
		held_card = card
		remove_from_hand(card)
		held_card.on_hold_start(self, manager)
	
	can_hold = false
	
	for sub : DebateSubscriber in manager.subscriber_array: await sub.on_card_hold_updated(held_card, self)

func remove_held_card():
	if held_card:
		var card = held_card
		held_card = null
		card.on_hold_end(self, manager)
	

func discard_card(card : Card):
	discard_pile.append(card)
	
	await card.on_discard(self, manager)

func add_to_hand(card : Card, index: int = -1):
	if index == -1 || index >= hand.size():
		hand.append(card)
	else:
		hand.insert(index, card)

func remove_from_hand(card : Card) -> bool:
	var index = hand.find(card)
	if index < 0: return false
	
	hand.remove_at(index)
	
	return true

func discard_from_hand(card : Card):
	if !remove_from_hand(card): return
	await discard_card(card)

func push_front_to_draw_pile(card: Card):
	draw_pile.push_front(card)

func append_to_draw_pile(card: Card):
	draw_pile.append(card)

func random_insert_to_draw_pile(card: Card):
	draw_pile.insert(randi() % (draw_pile.size() + 1), card)

func remove_from_draw_pile(card : Card):
	var index = draw_pile.find(card)
	
	if index < 0: return
	
	draw_pile.remove_at(index)

func add_to_deck(card : Card):
	_deck.add_to_deck(card)

func remove_from_deck(card : Card):
	_deck.remove_from_deck(card)
	card.on_banish(self, manager)

func draw_pile_push_front(card: Card):
	draw_pile.push_front(card)

func draw_pile_append(card: Card):
	draw_pile.append(card)

func draw_pile_random_insert(card: Card):
	draw_pile.insert(randi() % (draw_pile.size() + 1), card)
