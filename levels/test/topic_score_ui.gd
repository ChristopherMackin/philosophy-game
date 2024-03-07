@tool
extends Node

class_name TopicScoreUI

signal animation_finished

@export var progress_bar : TwoWayProgressBar
@export var positive_icon : TextureRect
@export var negative_icon : TextureRect

@export var topic : Topic:
	get: return topic
	set(val):
		topic = val
		if not topic:
			return
		
		positive_icon.texture = topic.positive_suit.icon
		negative_icon.texture = topic.negative_suit.icon
		progress_bar.positive_tint = topic.positive_suit.color
		progress_bar.negative_tint = topic.negative_suit.color
	
@export var score : float = 0:
	get: return score
	set(val):
		score = val
		progress_bar.value = val
@export var segment_count : int:
	get: return segment_count
	set(val):
		segment_count = val
		progress_bar.max_value = val
