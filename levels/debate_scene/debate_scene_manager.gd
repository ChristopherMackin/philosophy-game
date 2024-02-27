extends Node2D

class_name DebateSceneManager
@export var debate_manager : DebateManager
@export var proactive_character : Character
@export var reactive_character : Character

var debate_action_queue : Queue = Queue.new()

@export var meter_ui : MeterUI
@export var debate_ui : WorldspaceDebateUI

@export var player_ui : WorldspaceHandUI

var is_animation_locked := false

signal on_score_update(score : Vector2)

func _enter_tree():
	debate_action_queue.on_push = queue_animate
	debate_manager.connect_signals(self)
	debate_manager.init(proactive_character, reactive_character)

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

func on_starting_card_played(card : Card):
	debate_action_queue.push(func ():
		debate_ui.update_card(card)
	)

func on_follow_up_played(card : Card, suit_relationship : DebateSettings.SuitRelationship):
	debate_action_queue.push(func ():
		debate_ui.update_card(card)
	)

func on_hand_update(contestant : Contestant, hand_card_array : Array):
	if contestant.character == reactive_character:
		debate_action_queue.push(func ():
			player_ui.update_card_array(hand_card_array)
		)

func on_contest(starting_suit : Suit, follow_up_suit : Suit, winning_suit : Suit):
	print("%s wins the debate!" % (winning_suit.name if winning_suit else "No one"))

func on_debate_end():
	print("DEBATE OVER, score is %s" % debate_manager.score)
