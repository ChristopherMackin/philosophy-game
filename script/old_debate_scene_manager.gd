extends DebateSubscriber

class_name DebateSceneManager
@export var character_1 : Character
@export var character_2 : Character

var debate_action_queue : Queue = Queue.new()

@export var player_ui : HandUI
@export var score_board : ScoreBoard
@export var current_card_ui : CurrentCardUI
@export var debate_start_animator : AnimationPlayer

var is_animation_locked := false

func _ready():
	super._ready()
	debate_action_queue.on_push = queue_animate
	manager.init(character_1, character_2)
func queue_animate():
	if is_animation_locked:
		return
	
	is_animation_locked = true
	
	while debate_action_queue.size() > 0:
		await debate_action_queue.pop().call()
	
	is_animation_locked = false

func on_debate_start():
	var current_card = manager.current_card
	var player_hand = manager.contestant_2.hand.duplicate()
		
	debate_action_queue.push(func():
		player_ui.update_card_array(player_hand, current_card.data.suit)
		#contestant_display.play_card(current_card)
		#await contestant_display.animation_finished
		
		current_card_ui.update_card(current_card)
		debate_start_animator.play("debate_start")
		await debate_start_animator.animation_finished
	)

func on_player_change(contestnat : Contestant):
	pass

func on_card_played(previous : Card, follow_up : Card, contestant : Contestant):
	if contestant.character == character_1:
		character_1_play(previous, follow_up, contestant)
	elif contestant.character == character_2:
		character_2_play(previous, follow_up, contestant)
	
	var topic = manager.current_topic

func on_action_taken(type : DebateManager.CardActions):
	var topic = manager.current_topic
	var score = manager.current_topic_score
	var hand = manager.contestant_2.hand.duplicate()
	var suit = manager.current_card.data.suit
	
	debate_action_queue.push(func():
		score_board.update_topic(topic)
		score_board.update_score(score)
		player_ui.update_card_array(hand, suit)
	)

func character_1_play(previous : Card, follow_up : Card, contestant : Contestant):
	debate_action_queue.push(func():
		
		current_card_ui.update_card(follow_up)
	)

func character_2_play(previous : Card, follow_up : Card, contestant : Contestant):
	var hand = manager.contestant_2.hand.duplicate()
	
	debate_action_queue.push(func():
		player_ui.update_card_array(hand, follow_up.data.suit)
		
		await get_tree().create_timer(.5).timeout
		
		current_card_ui.update_card(follow_up)
		
		await get_tree().create_timer(.5).timeout
	)
