extends DebateSubscriber

@export var debate_settings : DebateSettings
@export var player : Character
@export var computer : Character

@onready var debate_profile : DebateProfileUI = $CharacterProfile
@onready var score_board : ScoreBoard = $ScoreBoard
@onready var player_hand_ui : PlayerHandUI = $PlayerHand
@onready var computer_hand_ui : ComputerHandUI = $ComputerHand
@onready var debate_start_animator := $DebateStartGraphic/AnimationPlayer
@onready var energy_pool := $EnergyPool
@onready var draw_pile_ui = $Draw

var action_queue : Queue = Queue.new()
var is_animation_locked := false

func _ready():
	super._ready()
	action_queue.on_push = queue_animate
	for topic in debate_settings.topic_array:
		score_board.add_topic(topic)
	
	manager.init(player, computer)

func queue_animate():
	if is_animation_locked:
		return
	
	is_animation_locked = true
	
	while action_queue.size() > 0:
		await action_queue.pop().call()
	
	is_animation_locked = false

func on_debate_start(starting_card : Card):
	action_queue.push(func():
		computer_card_played(starting_card)
		debate_start_animator.play("debate_start")
	)
	queue_update_player_hands()
	
func on_player_change(contestant : Contestant):
	if contestant.character == player:
		computer_turn_end()
		player_turn_begin(contestant.current_energy)
	else:
		player_turn_end()
		computer_turn_begin()
	
func on_card_played(card : Card, active_contestant : Contestant):
	if active_contestant.character == player:
		player_card_played(card, active_contestant)
	else:
		action_queue.push(func():
			await get_tree().create_timer(.7).timeout 
			computer_card_played(card)
		)
	
	queue_update_player_hands()
	
func on_action_taken(action : CardAction, is_positive : bool):
	var energy = manager.active_contestant.current_energy
	
	action_queue.push(func():
		energy_pool.set_energy(energy)
	)
	
	queue_update_player_hands()

func on_debate_finished():
	print("DEBATE FINISHED")

func player_turn_begin(current_energy : int):
	action_queue.push(func():
		player_hand_ui.enabled = true
		energy_pool.set_energy(current_energy)
	)

func player_turn_end():
	action_queue.push(func():
		player_hand_ui.enabled = false
	)

func computer_turn_begin():
	pass

func computer_turn_end():
	pass

func queue_update_player_hands():
	var player_hand := manager.player.hand
	var suit := manager.current_suit
	var deck_count := manager.player.deck.count
	
	action_queue.push(func():
		player_hand_ui.update_card_array(player_hand, suit)
		draw_pile_ui.set_count(deck_count)
	)

func player_card_played(card: Card, active_contestant : Contestant):
	action_queue.push(func():
		player_hand_ui.on_card_played(card)
		energy_pool.set_energy(active_contestant.current_energy)
	)

func computer_card_played(card : Card):
	computer_hand_ui.on_card_played(card)

func topic_score_updated(topic : Topic, score : int):
	action_queue.push(func():
		score_board.update_score(topic, score)
	)
