extends Resource

class_name DebateManager

@export var debate_settings : DebateSettings

var contestant_1 : Contestant
var contestant_2 : Contestant

enum CardActions{
	BUMP,
	CHANGE_TOPIC,
	CONTEST
}

var active_contestant : Contestant:
	get: return active_contestant
	set(val):
		for sub : DebateSubscriber in subscriber_array: sub.on_player_change(val)
		active_contestant = val

var inactive_contestant : Contestant:
	get:
		if contestant_1 == active_contestant:
			return contestant_2
		elif contestant_2 == active_contestant:
			return contestant_1
		else:
			return null

var contestants : Array[Contestant]

var previous_card : Card
var previous_suit : Suit:
	get: return previous_card.data.suit

var follow_up_card : Card
var follow_up_suit : Suit :
	get:
		return follow_up_card.data.suit

var current_card : Card
var current_suit : Suit:
	get: return current_card.data.suit

var topic_score_float_array : Array[float]
var current_topic_index : int

var current_topic : Topic:
	get:
		return debate_settings.topic_array[current_topic_index]
var current_topic_score: float:
	get: return topic_score_float_array[current_topic_index]
	set(val):
		topic_score_float_array[current_topic_index] = val

var subscriber_array : Array[DebateSubscriber]

func subscribe(subscriber):
	subscriber_array.append(subscriber)
func unsubscribe(subscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func init(character_1 : Character, character_2 : Character):
	for i in debate_settings.topic_array.size():
		topic_score_float_array.append(0)
	
	contestant_1 = Contestant.new(character_1)
	contestant_2 = Contestant.new(character_2)
	
	contestants.append(contestant_1)
	contestants.append(contestant_2)
	
	for c in contestants:
		c.ready_up()
	
	active_contestant = contestant_1
	
	game_loop()

func game_loop():
	await set_initial_card()
	active_contestant = inactive_contestant
	for sub : DebateSubscriber in subscriber_array: sub.on_debate_start()
	
	while not get_is_debate_over():
		await active_player_turn()
		active_contestant = inactive_contestant

func set_initial_card():
	current_card = await active_contestant.take_turn()
	follow_up_card = current_card
	current_topic_index = debate_settings.get_topic_index(current_suit)

func get_is_debate_over() -> bool:
	for score in topic_score_float_array:
		if abs(score) >= debate_settings.win_amount:
			return true
	
	return false

func active_player_turn():
		previous_card = current_card
		follow_up_card = await active_contestant.take_turn()
		current_card = follow_up_card
		
		for sub : DebateSubscriber in subscriber_array: sub.on_card_played(previous_card, follow_up_card, active_contestant)
		
		var suit_relation = debate_settings.get_suit_relationship(
				previous_suit, 
				follow_up_suit
			)
		
		match suit_relation:
			DebateSettings.SuitRelationship.SAME:
				current_topic_score += current_topic.suit_direction(follow_up_suit)
				
				for sub : DebateSubscriber in subscriber_array: sub.on_action_taken(CardActions.BUMP)
				
				if !get_is_debate_over(): await active_player_turn()
			DebateSettings.SuitRelationship.OFF_TOPIC:
				current_topic_index = debate_settings.get_topic_index(follow_up_suit)
				current_topic_score += current_topic.suit_direction(follow_up_suit)
				
				for sub : DebateSubscriber in subscriber_array: sub.on_action_taken(CardActions.CHANGE_TOPIC)
			DebateSettings.SuitRelationship.OPPOSING:
				var starting : int = 0
				#player gets an extra point since they just played a card
				var follow_up : int = 1
				
				for hand_card in contestant_1.hand:
					if hand_card.data.suit == previous_suit:
						contestant_1.discard_card(hand_card)
						starting += 1
					
				for hand_card in contestant_2.hand:
					if hand_card.data.suit == follow_up_suit:
						contestant_2.discard_card(hand_card)
						follow_up += 1
				
				var win_amount = follow_up - starting
				
				if win_amount > 0:
					current_card = follow_up_card
				else:
					current_card = previous_card
				
				current_topic_score += current_topic.suit_direction(current_suit) * win_amount
				
				for contestant : Contestant in contestants:
					contestant.draw_full_hand()
				
				for sub : DebateSubscriber in subscriber_array: sub.on_action_taken(CardActions.CONTEST)
			_:
				if !get_is_debate_over(): await active_player_turn()
			
		active_contestant.draw_full_hand()
