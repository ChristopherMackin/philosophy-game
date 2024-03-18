extends Resource

class_name DebateManager

@export var debate_settings : DebateSettings

var contestant_1 : Contestant
var contestant_2 : Contestant

var active_contestant : Contestant
var inactive_contestant : Contestant:
	get:
		if contestant_1 == active_contestant:
			return contestant_2
		elif contestant_2 == active_contestant:
			return contestant_1
		else:
			return null

var contestants : Array[Contestant]

var current_card : Card
var current_suit : Suit:
	get:
		return current_card.data.suit

var topic_score_float_array : Array[float]
var current_topic_index : int
var current_topic : Topic:
	get:
		return debate_settings.topic_array[current_topic_index]

var play_again : bool = false

var subscriber_array : Array

signal on_hand_update(contestant : Contestant, hand : Array[Card])
signal on_debate_end()

func connect_signals(node : Node):
	var signals := [
		on_hand_update,
		on_debate_end,
	]
	
	for sig : Signal in signals:
		var callable
		if node.has_method(sig.get_name()):
			callable = Callable(node, sig.get_name())
			sig.connect(callable)
		else:
			push_error("UNIMPLEMENTED: %s" % sig.get_name())

func init(character_1 : Character, character_2 : Character):
	for i in debate_settings.topic_array.size():
		topic_score_float_array.append(0)
	
	contestant_1 = Contestant.new(character_1)
	contestant_2 = Contestant.new(character_2)
	
	contestants.append(contestant_1)
	contestants.append(contestant_2)
	
	for contestant in contestants:
		contestant.on_hand_update.connect(func(con, hand) : on_hand_update.emit(con, hand))
		contestant.ready_up()
	
	active_contestant = contestant_1
	
	game_loop()

func game_loop():
	await set_initial_card()
	active_contestant = inactive_contestant
	
	while not get_is_debate_over():
		await active_player_turn()
		active_contestant = inactive_contestant
	
	on_debate_end.emit()

func set_initial_card():
	current_card = await active_contestant.take_turn()
	current_topic_index = debate_settings.get_topic_index(current_suit)

func get_is_debate_over() -> bool:
	for score in topic_score_float_array:
		if abs(score) >= debate_settings.win_amount:
			return true
	
	return false

func active_player_turn():
		var follow_up_card = await active_contestant.take_turn()
		var follow_up_suit = follow_up_card.data.suit
		
		var suit_relation = debate_settings.get_suit_relationship(
				current_suit, 
				follow_up_suit
			)
		
		match suit_relation:
			DebateSettings.SuitRelationship.SAME:
				topic_score_float_array[current_topic_index] += current_topic.suit_direction(follow_up_suit)
				if not get_is_debate_over() : await active_player_turn()
			DebateSettings.SuitRelationship.OFF_TOPIC:
				current_topic_index = debate_settings.get_topic_index(follow_up_suit)
				topic_score_float_array[current_topic_index] += current_topic.suit_direction(follow_up_suit)
			DebateSettings.SuitRelationship.OPPOSING:
				var starting : int = 0
				#player gets an extra point since they just played a card
				var follow_up : int = 1
				
				for hand_card in contestant_1.hand:
					if hand_card.data.suit == current_card.data.suit:
						contestant_1.discard_card(hand_card)
						starting += 1
					
				for hand_card in contestant_2.hand:
					if hand_card.data.suit == follow_up_suit:
						contestant_2.discard_card(hand_card)
						follow_up += 1
				
				var win_amount = follow_up - starting
				
				if win_amount > 0:
					current_card = follow_up_card
				
				topic_score_float_array[current_topic_index] += current_topic.suit_direction(current_suit) * win_amount
				
				for contestant : Contestant in contestants:
					contestant.draw_full_hand()
			_:
				if not get_is_debate_over() : await active_player_turn()
			
		active_contestant.draw_full_hand()
