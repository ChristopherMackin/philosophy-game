extends Resource

class_name DebateManager

@export var debate_settings : DebateSettings

var proactive_contestant : Contestant
var reactive_contestant : Contestant
var contestants : Array
var active_contestant : Contestant:
	get: return active_contestant
	set(value):
		active_contestant = value
		on_character_changed.emit(active_contestant.character, inactive_contestant.character)
var inactive_contestant : Contestant:
	get:
		if active_contestant == proactive_contestant:
			return reactive_contestant
		else:
			return proactive_contestant
	set(val):
		if val == proactive_contestant:
			active_contestant = reactive_contestant
		else:
			active_contestant = proactive_contestant

var current_card : Card
var score : Vector2:
	get: return score
	set(value):
		score = value
		on_score_updated.emit(value)
	
var play_again : bool = false

var subscriber_array : Array

signal on_score_updated(new_score : Vector2)
signal on_character_changed(active : Character, inactive : Character)
signal on_card_played(character : Character, card : Card)

signal on_bump()
signal on_suit_change(suit : Suit)
signal on_conflict()
#Fix this one soon
signal on_debate_end()

func connect_signals(node : Node):
	var signals := [
		on_character_changed,
		on_card_played,
		on_bump,
		on_suit_change,
		on_conflict,
		on_debate_end,
		on_score_updated
	]
	
	for sig : Signal in signals:
		var callable
		if node.has_method(sig.get_name()):
			callable = Callable(node, sig.get_name())
			sig.connect(callable)
		else:
			push_error("UNIMPLEMENTED: %s" % sig.get_name())

func init(character_1 : Character, character_2 : Character):
	proactive_contestant = Contestant.new(character_1)
	reactive_contestant = Contestant.new(character_2)
	
	contestants.append(proactive_contestant)
	contestants.append(reactive_contestant)
	
	for contestant : Contestant in contestants:
		contestant.deck.reset_deck()
		contestant.draw_full_hand()
	
	active_contestant = reactive_contestant
	
	game_loop()

func game_loop():
	while !get_is_debate_over():
		var card_to_play = await active_contestant.take_turn()
		play_card(card_to_play)
		
		if !play_again:
			active_contestant.draw_full_hand()
			
			active_contestant = inactive_contestant
		else:
			play_again = false
	
	on_debate_end.emit()

func get_is_debate_over():
	return abs(score.x) >= debate_settings.win_amount || abs(score.y) >= debate_settings.win_amount

func play_card(card: Card):	
	on_card_played.emit(active_contestant.character, card)
	#move this to later soon
	active_contestant.discard_card(card)
	
	#Set the first card of the debate
	if current_card == null:
		current_card = card
	
	elif current_card.data.suit == card.data.suit:
		score += debate_settings.get_suit_vector(card.data.suit)
		play_again = true
		on_bump.emit()
	
	elif current_card.data.suit != debate_settings.get_opposing_suit(card.data.suit):
		score += debate_settings.get_suit_vector(card.data.suit)
		current_card = card
		on_suit_change.emit(card.data.suit)

	elif current_card.data.suit == debate_settings.get_opposing_suit(card.data.suit):
		var new_suit : int = 1
		var contested_suit : int = 0
		
		for hand_card in active_contestant.hand_card_array:
			if hand_card.data.suit == card.data.suit:
				active_contestant.discard_card(hand_card)
				new_suit += 1
			
		
		for hand_card in inactive_contestant.hand_card_array:
			if hand_card.data.suit == debate_settings.get_opposing_suit(card.data.suit):
				inactive_contestant.discard_card(hand_card)
				contested_suit += 1
		
		var win_amount = new_suit - contested_suit
		
		print("%s: %s vs %s: %s" %
		[
			current_card.data.suit.name, 
			contested_suit, 
			card.data.suit.name,
			new_suit,
		])
		
		if win_amount > 0:
			current_card = card
		
		score += debate_settings.get_suit_vector(card.data.suit) * win_amount
		
		print("New Suit: %s, score is %s" % [current_card.data.suit.name, score])
		
		for x : Contestant in contestants:
			x.draw_full_hand()
	
	return true
