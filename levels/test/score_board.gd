extends HBoxContainer

class_name ScoreBoard

@export var topic_score : PackedScene
@export var debate_settings : DebateSettings

var topic_ui_tuple_array : Array[Tuple]

func add_topic(topic : Topic):
	var score : TopicScoreUI = topic_score.instantiate()
	add_child(score)
	score.topic = topic
	score.segment_count = debate_settings.win_amount
	
	topic_ui_tuple_array.append(Tuple.new(topic, score))

func update_score(topic : Topic, score : int):
	var index = topic_ui_tuple_array.map(func(x): return x.val1).find(topic)
	topic_ui_tuple_array[index].val2.score = score
	
	var i = 0
	for topic_ui : TopicScoreUI in topic_ui_tuple_array.map(func(x): return x.val2):
		var color = Color.WHITE if i == index else Color.WEB_GRAY
		topic_ui.modulate = color
		i += 1
