extends Control

class_name ScoreBoard

@export var topic_score_prefab : PackedScene
@export var debate_settings : DebateSettings
var topic_score_array : Array[Topic]

func _ready():
	for topic in debate_settings.topic_array:
		add_topic(topic, debate_settings.win_amount)

func add_topic(topic : Topic, win_amount : int):
	var topic_score : TopicScore = topic_score_prefab.instantiate()
	topic_score.topic = topic
	topic_score.segment_count = win_amount
	topic_score_array.append(topic_score)
	add_child(topic_score)
