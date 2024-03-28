extends Node2D

@export var score_board : ScoreBoard

@export var topic_array : Array[Topic]
@export var character : Character
var contestant : Contestant

@export var hand_ui : HandUI

@export var loop : bool = true

@export var debate_settings : DebateSettings

@onready var rng = RandomNumberGenerator.new()

var index : int = 0

func _ready():
	for topic : Topic in topic_array:
		score_board.add_topic(topic)
	
	contestant = Contestant.new(character)
	contestant.ready_up()
	
	while loop:
		hand_ui.update_card_array(contestant.hand)
		
		var card = null
		while !contestant.hand.has(card):
			card = await contestant.brain.think()
		
		contestant.discard_card(card)
		hand_ui.on_card_played(card)
		
		var index = debate_settings.get_topic_index(card.data.suit)
		var topic = debate_settings.topic_array[index]
		
		score_board.update_topic(topic)
		score_board.update_score(rng.randi_range(1, 5) * topic.suit_direction(card.data.suit))
