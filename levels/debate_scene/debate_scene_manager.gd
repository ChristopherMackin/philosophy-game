extends Node2D

class_name DebateSceneManager
@export var debate_manager : DebateManager
@export var character_1 : Character
@export var character_2 : Character

var debate_action_queue : Queue = Queue.new()

@export var debate_history : ConversationHistoryManager

@export var player_ui : HandUI
@export var score_board : ScoreBoard
@export var current_card_ui : CurrentCardUI

var is_animation_locked := false

func _ready():
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

func on_updated(var_name : String, old_value, new_value):
	var method_name = "on_%s_updated" % var_name
	if has_method(method_name):
		Callable(self, method_name).call(old_value, new_value)

func on_active_contestant_updated(old_contestant, new_contestant):
	print(new_contestant.name)

func on_current_topic_updated(old_value, new_value):
	debate_action_queue.push(func():
		score_board.update_topic(new_value)
	)

func on_current_topic_score_updated(old_value, new_value):
	debate_action_queue.push(func():
		score_board.update_score(new_value)
		await get_tree().create_timer(.5).timeout
	)

func on_current_card_updated(old_value, new_value):
	player_ui.orgainze_cards(new_value.data.suit)
	current_card_ui.update_card(new_value)

func on_contestant_2_hand_updated(old_value, new_value):
	player_ui.update_card_array(new_value)
