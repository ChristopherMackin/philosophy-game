extends BoxContainer

class_name ScoreBoard

@export var topic_score : PackedScene
@export var debate_settings : DebateSettings

var topic_score_dictionary : Dictionary

func add_topic(topic : Topic):
	var score : TopicScoreUI = topic_score.instantiate()
	add_child(score)
	score.topic = topic
	score.segment_count = debate_settings.win_amount
	
	topic_score_dictionary[topic] = score

func update_score(topic : Topic, amount : int):
	if topic_score_dictionary.has(topic):
		topic_score_dictionary[topic].score = amount
