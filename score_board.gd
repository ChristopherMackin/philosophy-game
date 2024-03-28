extends HBoxContainer

class_name ScoreBoard

@export var topic_score : PackedScene
@export var debate_settings : DebateSettings

var topic_ui_tuple_array : Array[Tuple]
var current_topic_index : int = -1

func add_topic(topic : Topic):
	var score : TopicScoreUI = topic_score.instantiate()
	add_child(score)
	score.topic = topic
	score.segment_count = debate_settings.win_amount
	
	topic_ui_tuple_array.append(Tuple.new(topic, score))

func update_topic(topic: Topic):
	current_topic_index = topic_ui_tuple_array.map(func(x): return x.val1).find(topic)

func update_score(score : int):
	if current_topic_index == -1:
		return
	
	topic_ui_tuple_array[current_topic_index].val2.score = score
	
	var i = 0
	for topic_ui : TopicScoreUI in topic_ui_tuple_array.map(func(x): return x.val2):
		var color = Color.WHITE if i == current_topic_index else Color.WEB_GRAY
		topic_ui.modulate = color
		i += 1
