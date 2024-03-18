extends Node2D

@export var score_board : ScoreBoard

@export var topic_array : Array[Topic]

@onready var rng = RandomNumberGenerator.new()

var index : int = 0

func _ready():
	
	for topic : Topic in topic_array:
		score_board.add_topic(topic)
	
	while true:
		index = (index + 1) % topic_array.size()
		score_board.update_score(topic_array[index], rng.randi_range(-5, 5))
		await get_tree().create_timer(1).timeout
