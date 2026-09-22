extends CardAction

class_name MoveTokenCountersToCardCollectionCardAction

@export var from_collection: CardCollectionContainer
@export var to_collection: CardCollectionContainer
@export var amount: int = -1
@export_enum("First", "Even", "Across")var spread_mode: int

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	if amount == 0: return true
	
	from_collection.init(caller, player, manager)
	to_collection.init(caller, player, manager)
	
	var from_cards := await from_collection.get_collection_cards()
	#TODO: Fix racing condition and remove timer await
	await GlobalTimer.wait_for_seconds(.01)
	var to_cards := await to_collection.get_collection_cards()
	
	if from_cards.size() <= 0 || to_cards.size() <=0: return true
	
	match spread_mode:
		0: _first(from_cards, to_cards)
		1: _even(from_cards, to_cards)
		2: _across(from_cards, to_cards)
	
	return true

func _first(from_cards: Array[Card], to_cards: Array[Card]):
	var to_card := to_cards[0]
	
	if amount <= -1:
		for card in from_cards:
			to_card.base_token_counter += card.base_token_counter
			card.base_token_counter = 0
	else:
		var i := 0
		for card in from_cards:
			to_card.base_token_counter += card.base_token_counter
			card.base_token_counter = 0
			i += 1
			if i >= amount: return

func _even(from_cards: Array[Card], to_cards: Array[Card]):
	var token_counters = _pop_token_counters_from_card_collection(from_cards)
	
	if token_counters <= 0: return
	
	var amount_per_card: int = token_counters / to_cards.size()
	var remainder: int = fmod(token_counters, to_cards.size())
	
	var i = 1
	for card in to_cards:
		var amount_to_add = amount_per_card
		if i <= remainder: 
			amount_to_add += 1
			i += 1
		card.base_token_counter += amount_to_add

func _across(from_cards: Array[Card], to_cards: Array[Card]):	
	var size = min(from_cards.size(), to_cards.size())
	
	if amount <= -1:
		for i in size:
			to_cards[i].base_token_counter += from_cards[i].base_token_counter
			from_cards[i].base_token_counter = 0
	
	else:
		for i in size:
			var btc = from_cards[i].base_token_counter
			if btc <= amount:
				from_cards[i].base_token_counter -= amount
				to_cards[i].base_token_counter += amount
			else:
				from_cards[i].base_token_counter -= btc
				to_cards[i].base_token_counter += btc

func _pop_token_counters_from_card_collection(card_array: Array[Card]):
	var token_counters = 0
	
	if amount <= -1:
		token_counters = card_array.reduce(func(accum, card: Card):
				var btc = card.base_token_counter
				card.base_token_counter = 0
				return accum + btc
		)
	
	else:
		token_counters = card_array.reduce(func(accum, card: Card):
			var btc = card.base_token_counter
			if btc <= amount:
				card.base_token_counter -= amount
				return accum + amount
			else:
				card.base_token_counter = 0
				return accum + btc
		)
		
	return token_counters
