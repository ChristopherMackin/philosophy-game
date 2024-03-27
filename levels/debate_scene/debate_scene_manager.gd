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
@export var debate_start_animator : AnimationPlayer
@export var contestant_display : ContestantDisplay

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

func on_debate_start():
	debate_action_queue.push(func():
		debate_start_animator.play("debate_start")
	)

func on_card_played(previous : Card, follow_up : Card, contestant : Contestant):
	if contestant.character == character_1:
		debate_action_queue.push(func():
			contestant_display.play_card(follow_up)
			await contestant_display.animation_finished
		)

func on_starting_card_played(card : Card):
	debate_action_queue.push(func():
		contestant_display.play_card(card)
		await contestant_display.animation_finished
	)

func on_current_card_updated(card : Card):
	debate_action_queue.push(func():
		current_card_ui.update_card(card)
		player_ui.orgainze_cards(card.data.suit)
	)

func on_current_topic_updated(topic : Topic):
	debate_action_queue.push(func():
		score_board.update_topic(topic)
	)

func on_current_topic_score_updated(score : float):
	debate_action_queue.push(func():
		score_board.update_score(score)
		await get_tree().create_timer(.5).timeout
	)

func on_hand_updated(contestant : Contestant, hand : Array[Card]):
	debate_action_queue.push(func():
		if(contestant.character == character_2):
			player_ui.update_card_array(hand)
	)
