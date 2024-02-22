extends Node2D

class_name DebateSceneManager

@export var debate_manager : DebateManager
@export var character_1 : Character
@export var character_2 : Character

var debate_action_queue : Queue = Queue.new()

@export var meter_ui : MeterUI

var is_animation_locked := false

signal on_score_update(score : Vector2)

func _ready():
	debate_manager.connect_signals(self)
	
	debate_manager.init(character_1, character_2)

func queue_animate():
	if is_animation_locked:
		return
	
	is_animation_locked = true
	
	while debate_action_queue.size() > 0:
		await debate_action_queue.pop().call()
	
	is_animation_locked = false

func on_debate_end():
	print("DEBATE OVER, score is %s" % debate_manager.score)

func on_score_updated(new_score : Vector2):
	debate_action_queue.push(func():
		meter_ui.update_score(new_score)
		await meter_ui.animation_finished
	)
	
	queue_animate()
