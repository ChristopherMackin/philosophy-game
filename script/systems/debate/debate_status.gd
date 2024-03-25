extends Object

class_name DebateStatus

var contestant_1_name : String
var contestant_1_hand : Array[Card]

var contestant_2_name : String
var contestant_2_hand : Array[Card]

var active_contestant : String
var inactive_contestant : String:
	get:
		if active_contestant == contestant_1_name:
			return contestant_2_name
		else:
			return contestant_1_name
	set (val):
		if val == contestant_1_name:
			active_contestant = contestant_2_name
		else:
			active_contestant =  contestant_1_name

var previous_card : Card
var previous_suit : Suit:
	get:
		return previous_card.data.suit

var follow_up_card : Card
var follow_up_suit : Suit :
	get:
		return follow_up_card.data.suit

var current_card : Card
var current_suit : Suit:
	get:
		return current_card.data.suit

var debate_settings : DebateSettings
var topic_score_float_array : Array[float]
var current_topic_index : int
var current_topic : Topic:
	get:
		return debate_settings.topic_array[current_topic_index]

func _init(manager : DebateManager):
	contestant_1_name = manager.contestant_1.name
	contestant_1_hand = manager.contestant_1.hand.duplicate()
	
	contestant_2_name = manager.contestant_2.name
	contestant_2_hand = manager.contestant_2.hand.duplicate()
	
	active_contestant = manager.active_contestant.name
	
	previous_card = manager.previous_card
	follow_up_card = manager.follow_up_card
	current_card = manager.current_card
	
	debate_settings = manager.debate_settings
	
	topic_score_float_array = manager.topic_score_float_array.duplicate()
	
	current_topic_index = manager.current_topic_index
