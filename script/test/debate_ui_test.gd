extends Node2D

@export var score_board : ScoreBoard

@export var topic_array : Array[Topic]

@export var hand_ui : HandUI

@export var card_deck_config_array : Array[CardDeckConfig]
var card_array : Array[Card]

@export var loop : bool = true

@export var debate_settings : DebateSettings

@onready var rng = RandomNumberGenerator.new()

var index : int = 0

func _ready():
	
	for topic : Topic in topic_array:
		score_board.add_topic(topic)
	
	for config in card_deck_config_array:
		for i in config.count:
			card_array.append(Card.new(config.card_data))
	
	while loop:
		var card = card_array[rng.randi_range(0, card_array.size() - 1)]
		
		hand_ui.update_card_array(card_array, card.data.suit)
		
		var index = debate_settings.get_topic_index(card.data.suit)
		await get_tree().create_timer(1).timeout
