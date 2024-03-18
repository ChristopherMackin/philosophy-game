extends Node2D

class_name DebateSceneManager
@export var debate_manager : DebateManager
@export var character_1 : Character
@export var character_2 : Character

var debate_action_queue : Queue = Queue.new()

@export var debate_history : ConversationHistoryManager

@export var player_ui : HandUI

var is_animation_locked := false

signal on_score_update(score : Vector2)

func _enter_tree():
	debate_action_queue.on_push = queue_animate
	debate_manager.connect_signals(self)
	debate_manager.init(character_1, character_2)

func queue_animate():
	if is_animation_locked:
		return
	
	is_animation_locked = true
	
	while debate_action_queue.size() > 0:
		await debate_action_queue.pop().call()
	
	is_animation_locked = false

func on_hand_update(contestant : Contestant, hand : Array[Card]):
	if contestant.character == character_2:
		debate_action_queue.push(func ():
			player_ui.update_card_array(hand)
		)

func on_debate_end():
	print("DEBATE OVER")
	
	for score in debate_manager.topic_score_float_array:
		print(score)
