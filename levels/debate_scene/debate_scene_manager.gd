extends Node2D

class_name DebateSceneManager
@export var debate_manager : DebateManager
@export var character_1 : Character
@export var character_2 : Character

var debate_action_queue : Queue = Queue.new()

@export var meter_ui : MeterUI
@export var debate_ui : WorldspaceDebateUI

var is_animation_locked := false

signal on_score_update(score : Vector2)

func _enter_tree():
	debate_action_queue.on_push = queue_animate

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

func on_score_updated(new_score : Vector2):
	debate_action_queue.push(func():
		meter_ui.update_score(new_score)
		await meter_ui.animation_finished
	)

func on_reactive_start(hand_card_array : Array):
	pass

func on_starting_card_played(card : Card):
	debate_action_queue.push(func ():
		debate_ui.update_card(card)
	)

func on_proactive_start(hand_card_array : Array):
	pass

func on_follow_up_played(card : Card, suit_relationship : DebateSettings.SuitRelationship):
	debate_action_queue.push(func ():
		debate_ui.update_card(card)
	)

func on_contest(starting_suit : Suit, follow_up_suit : Suit, winning_suit : Suit):
	print("%s wins the debate!" % winning_suit.name)

func on_debate_end():
	print("DEBATE OVER, score is %s" % debate_manager.score)
