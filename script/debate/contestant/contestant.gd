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
var current_energy : int
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
		for action in card.on_turn_start_card_actions:
			await action.invoke(card, self, manager)

func end_turn():
	for card : Card in hand.duplicate():
		for action in card.on_turn_end_card_actions:
			await action.invoke(card, self, manager)
	
	if held_card:
		for action in held_card.on_hold_stay_card_actions:
			await action.invoke(held_card, self, manager)
	
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
	
	var response = await select(SelectionRequest.new(hand))
	var card = response.data
	
	match response.what:
		"play":
			if playable_cards.has(card):
				remove_from_hand(card)
		"hold":
			hold_card(card)
	
	return response

func select(request : SelectionRequest) -> SelectionResponse:
	var is_valid_selection : bool = false
	return await _brain.select(request)

func view(options : Array, what : String = "view", type : String = "card"):
	await _brain.view(options, what, type)

func hold_card(card : Card):
	if !can_hold:
		return
	
	if held_card:
		var index = hand.find(card)
		add_to_hand(held_card, index)
		for action : CardAction in held_card.on_hold_end_card_actions:
			await action.invoke(held_card, self, manager)
	
	if card:
		held_card = card
		remove_from_hand(card)
		for action : CardAction in held_card.on_hold_start_card_actions:
			await action.invoke(held_card, self, manager)
	
	can_hold = false
	
	for sub : DebateSubscriber in manager.subscriber_array: await sub.on_card_hold_updated(held_card, self)

func discard_card(card : Card):
	discard_pile.append(card)
	
	for action in card.on_discard_card_actions:
		await action.invoke(card, self, manager)

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

func add_to_draw_pile(card : Card):
	draw_pile.append(card)
	draw_pile.shuffle()

func remove_from_draw_pile(card : Card):
	var card_bases = draw_pile.filter(func(x): return x.base)
	var index = card_bases.find(card.base)
	
	if index < 0: return
	
	draw_pile.remove_at(index)
	draw_pile.shuffle()

func add_to_deck(card : Card):
	_deck.add_to_deck(card)

func remove_from_deck(card : Card):
	_deck.remove_from_deck(card)
	for action in card.on_banish_card_actions:
		await action.invoke(card, self, manager)
