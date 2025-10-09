extends Object

class_name Contestant

var manager : DebateManager
var character : Character
var hand : CardCollection = CardCollection.new()
var draw_pile : CardCollection
var discard_pile : CardCollection = CardCollection.new()
var playable_cards : Array[Card]:
	get: return hand.get_cards().filter(func(x): return x.cost <= current_energy)
var held_card : CardCollection = CardCollection.new()
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
var blackboard : Blackboard:
	get: return character.blackboard

var status_effects: Array[StatusEffect]
var can_play_condition_effects: Array[ConditionEffect]
var can_draw_condition_effects: Array[ConditionEffect]

var can_play:
	get:
		for condition in can_play_condition_effects:
			if !condition.check(): return false 
		return current_energy > 0 && playable_cards.size() > 0
var can_draw:
	get:
		for condition in can_draw_condition_effects:
			if !condition.check(): return false  
		return hand.size() < hand_limit && draw_pile.size() > 0

func character_is(character : Character):
	return self.character == character

func _init(character : Character, manager : DebateManager):
	self.manager = manager
	self.character = character
	self.character.brain.contestant = self
	
	hand.on_added.add_listener(func(card: Card): await card.on_draw(self, manager))
	hand.on_added.add_listener(func(card: Card):
		for sub in manager.subscribers: await sub.on_card_drawn(card, self)
	)
	
	draw_pile = _deck.create_draw_pile(manager)
	draw_pile.on_added.add_listener(func(card: Card): await card.destroy_token())
	draw_pile.on_removed.add_listener(func(card: Card): await card.generate_token())
	
	discard_pile.on_added.add_listener(func(card: Card): card.on_discard(self, manager))

func ready_up():
	await draw_full_hand()
	current_energy = energy_level

func _draw_card():
	var card = draw_pile.get_card_at_index(0)
	await hand.push_back(card)

func draw_specified_card(card : Card) -> bool:
	if hand.size() >= hand_limit || draw_pile.size() <= 0: return false
	
	await hand.push_back(draw_pile.get_card(card))	
	
	return true

func draw_at_index(index : int) -> bool:
	if hand.size() >= hand_limit || draw_pile.size() <= 0: return false
	
	await hand.push_back(draw_pile.get_card_at_index(index))	
	
	return true

func draw_number_of_cards(amount : int):
	while amount > 0 && can_draw:
		await _draw_card()
		amount -= 1

func draw_full_hand():
	while hand.size() < draw_limit && can_draw:
		await _draw_card()

func start_turn():
	for card : Card in hand.get_cards():
		await card.on_turn_start(self, manager)

func end_turn():
	for card : Card in hand.get_cards():
		await card.on_turn_end(self, manager)
	
	if held_card.size() > 0:
		for card in held_card.get_cards():
			await card.on_hold_stay(self, manager)
	
	for card in hand.get_cards():
		for modifier : CardCostModifier in card.cost_modifiers.filter(func(x): return x.can_expire).duplicate():
			modifier.turn_lifetime -= 1
			if modifier.turn_lifetime <= 0:
				var index = card.cost_modifiers.find(modifier)
				card.cost_modifiers.remove_at(index)
	
	for status_effect: StatusEffect in status_effects.filter(func(x): return x.can_expire).duplicate():
		status_effect.turn_lifetime -= 1
		if status_effect.turn_lifetime <= 0:
			status_effect.remove(self)
	
	await draw_full_hand()
	
	if current_energy < energy_level || !manager.debate_settings.retain_excess_energy:
		current_energy = energy_level
	
	can_hold = true

func phase_end():
	if manager.debate_settings.redraw_on_hand_depleted && hand.size() <= 0:
		await draw_full_hand()

func take_turn() -> SelectionResponse:
	var valid_response := false
	var response = null
	
	while(!valid_response):
		response = await select(SelectionRequest.new(hand.get_cards()))
		valid_response = true
		var card = response.data
		
		match response.what:
			"play":
				valid_response = playable_cards.has(card)
			"hold":
				if can_hold:
					await hold_card(card)
				else: valid_response = false
				
	return response

func select(request : SelectionRequest) -> SelectionResponse:
	return await _brain.select(request)

func hold_card(card : Card):
	if held_card.size() > 0:
		var index = hand.get_card_index(card)
		var old_held_card = held_card.get_card_at_index(0)
		await held_card.push_back(card)
		await hand.insert(index, old_held_card)
	
	if card:
		await held_card.push_back(card)
	
	can_hold = false
	
	for sub in manager.subscribers: await sub.on_card_hold_updated(held_card.get_card_at_index(0), self)

func remove_held_card():
	if held_card.size() > 0:
		var card = held_card.get_card_at_index(0)
		held_card.remove(card)

func add_to_deck(card : Card):
	_deck.add_to_deck(card)

func remove_from_deck(card : Card):
	_deck.remove_from_deck(card)
	await card.on_banish(self, manager)
