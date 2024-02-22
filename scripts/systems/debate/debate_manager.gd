extends Resource

class_name DebateManager

@export var debate_settings : DebateSettings

var proactive_contestant : Contestant
var reactive_contestant : Contestant

var starting_card : Card
var follow_up_card : Card
var starting_suit : Suit:
	get: return starting_card.data.suit
var follow_up_suit : Suit:
	get: return follow_up_card.data.suit

var score : Vector2:
	get: return score
	set(value):
		score = value
		on_score_updated.emit(value)
	
var play_again : bool = false

var subscriber_array : Array

signal on_score_updated(new_score : Vector2)
signal on_proactive_start(hand_card_array : Array)
signal on_starting_card_played(card : Card)
signal on_reactive_start(hand_card_array : Array)
signal on_follow_up_played(card: Card, suit_relation : DebateSettings.SuitRelationship)
#Fix this one soon
signal on_contest(starting_suit : Suit, follow_up_suit : Suit, winning_suit : Suit)

signal on_debate_end()

func connect_signals(node : Node):
	var signals := [
		on_proactive_start,
		on_starting_card_played,
		on_reactive_start,
		on_follow_up_played,
		on_score_updated,
		on_contest,
		on_debate_end,
	]
	
	for sig : Signal in signals:
		var callable
		if node.has_method(sig.get_name()):
			callable = Callable(node, sig.get_name())
			sig.connect(callable)
		else:
			push_error("UNIMPLEMENTED: %s" % sig.get_name())

func init(proactive_character : Character, reactive_character : Character):
	proactive_contestant = Contestant.new(proactive_character)
	reactive_contestant = Contestant.new(reactive_character)
	
	proactive_contestant.ready_up()
	reactive_contestant.ready_up()
	
	game_loop()

func game_loop():
	while !get_is_debate_over():
		on_proactive_start.emit(proactive_contestant.hand_card_array)
		proactive_play()
		
		on_reactive_start.emit(reactive_contestant.hand_card_array)
		reactive_play()
	
	on_debate_end.emit()

func get_is_debate_over():
	return abs(score.x) >= debate_settings.win_amount || abs(score.y) >= debate_settings.win_amount

func proactive_play():
	starting_card = await proactive_contestant.take_turn()
	proactive_contestant.draw_full_hand()
	on_starting_card_played.emit(starting_card)

func reactive_play():
		follow_up_card = await reactive_contestant.take_turn()
		var suit_relation = debate_settings.get_suit_relationship(
				starting_suit, 
				follow_up_suit
			)
		on_follow_up_played.emit(follow_up_card, suit_relation)
		
		match suit_relation:
			DebateSettings.SuitRelationship.SAME:
				score += debate_settings.get_suit_vector(follow_up_suit)
				if not get_is_debate_over() : reactive_play()
			DebateSettings.SuitRelationship.COMPLEMENTARY:
				score += debate_settings.get_suit_vector(follow_up_suit)
			DebateSettings.SuitRelationship.OPPOSING:
				var starting : int = 0
				#player gets an extra point since they just played a card
				var follow_up : int = 1
				
				for hand_card in proactive_contestant.hand_card_array:
					if hand_card.data.suit == starting_card.data.suit:
						proactive_contestant.discard_card(hand_card)
						starting += 1
					
				for hand_card in reactive_contestant.hand_card_array:
					if hand_card.data.suit == follow_up_suit:
						reactive_contestant.discard_card(hand_card)
						follow_up += 1
				
				var win_amount = follow_up - starting
				
				print("%s: %s vs %s: %s" %
				[
					starting_suit.name, 
					starting, 
					follow_up_suit.name,
					follow_up,
				])
				
				var winning_suit
				
				if win_amount > 0:
					winning_suit = follow_up_suit
				elif win_amount < 0:
					winning_suit = starting_suit
				
				score += debate_settings.get_suit_vector(winning_suit) * win_amount
				
				on_contest.emit(starting_suit, follow_up_suit, winning_suit)
				
				proactive_contestant.draw_full_hand()
				reactive_contestant.draw_full_hand()
			_:
				if not get_is_debate_over() : reactive_play()
