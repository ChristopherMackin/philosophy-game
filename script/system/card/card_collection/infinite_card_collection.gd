extends CardCollection

class_name InfiniteCardCollection

var original_draw_pile = []

func _init(cards: Array[Card] = []):
	original_draw_pile = cards
	
	on_removed.add_listener(func(card: Card): if _cards.size() <= 0: replinish_cards())
	replinish_cards()

func replinish_cards():
	var cards = []
	for card in original_draw_pile:
		cards.append(card.duplicate())
	
	cards.shuffle()
	
	for card in cards:
		push_back(card)

func replace(cards: Array[Card]):
	for card in _cards:
		remove(card)
	
	for card in cards:
		push_back(card)

func push_front(card: Card):
	_reparent_card_to_self(card)
	_cards.push_front(card)
	await on_added.invoke(card)

func push_back(card: Card):
	_cards.push_back(card)
	_reparent_card_to_self(card)
	await on_added.invoke(card)

func insert(index: int, card: Card):
	_reparent_card_to_self(card)
	_cards.insert(index, card)
	await on_added.invoke(card)

func insert_random(card: Card):
	insert(randi() % (_cards.size() + 1), card)

func _reparent_card_to_self(card: Card):
	if card.collection: card.collection.remove(card)
	card.collection = self

func remove(card: Card):
	var index = _cards.find(card)
	if index >= 0:
		_cards.remove_at(index)
	
	card.collection = null
	
	await on_removed.invoke(card)

func shuffle():
	_cards.shuffle()

func get_cards(): return _cards.duplicate()

func get_card(card: Card):
	var index = _cards.find(card)
	if index >= 0:
		return _cards[index]

func get_card_at_index(index: int):
	if index < 0: return
	
	return _cards[index]

func get_card_index(card: Card):
	return _cards.find(card)

func size():
	return 999
