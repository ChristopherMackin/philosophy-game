extends DebateSubscriber

@export var debate_settings : DebateSettings
@export var player : Character
@export var computer : Character

@onready var debate_start_animator : AwaitAnimator = $"../DebateStartGraphic/AnimationPlayer"
@onready var debate_profile : DebateProfileUI = $"../CharacterProfile"
@onready var computer_hand_ui : ComputerHandUI = $"../ComputerHand"
@onready var player_hand_ui : PlayerHandUI = $"../PlayerHand"
@onready var score_board : ScoreBoard = $"../ScoreBoard"
@onready var energy_pool : EnergyPool = $"../EnergyPool"
@onready var draw_pile_ui : DrawPileUI = $"../Draw"

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
	var player_hand = manager.player.hand.duplicate();
	var deck_count := manager.player.deck.count
	var energy = manager.player.current_energy
	var suit = manager.current_suit
	
	action_queue.push(func():
		player_hand_ui.enabled = false;
		energy_pool.set_energy(energy)
		draw_pile_ui.set_count(deck_count)
		player_hand_ui.update_card_array(player_hand, suit)
		
		await Util.await_all([
			func(): await debate_start_animator.play_await("debate_start"),
			func(): await computer_hand_ui.on_card_played(starting_card)
		])
	)

func on_player_change(contestant : Contestant):
	var player_hand = manager.player.hand.duplicate();
	var deck_count := manager.player.deck.count
	var energy = manager.player.current_energy
	var suit = manager.current_suit
	
	match contestant.character:
		player:
			action_queue.push(func():
				player_hand_ui.enabled = true;
				energy_pool.set_energy(energy)
				player_hand_ui.update_card_array(player_hand, suit)
			)
		computer:
			action_queue.push(func():
				player_hand_ui.enabled = false;
				draw_pile_ui.set_count(deck_count)
			)

func on_card_played(card: Card, active_contestant : Contestant):
	var player_hand := manager.player.hand
	var deck_count := manager.player.deck.count
	var energy := active_contestant.current_energy
	var suit := manager.current_suit

	match active_contestant.character:
		player:
			action_queue.push(func():
				energy_pool.set_energy(energy)
				await player_hand_ui.on_card_played(card)
				player_hand_ui.update_card_array(player_hand, suit)
				draw_pile_ui.set_count(deck_count)
			)
		computer:
			action_queue.push(func():
				await get_tree().create_timer(.7).timeout
				await computer_hand_ui.on_card_played(card)
			)

func on_action_taken(action : CardAction, is_positive : bool):
	var player_hand = manager.player.hand.duplicate();
	var deck_count := manager.player.deck.count
	var energy = manager.player.current_energy
	var suit = manager.current_suit
	
	action_queue.push(func():
		energy_pool.set_energy(energy)
		draw_pile_ui.set_count(deck_count)
		player_hand_ui.update_card_array(player_hand, suit)
	)

func topic_score_updated(topic : Topic, score : int):
	action_queue.push(func():
		score_board.update_score(topic, score)
	)

func on_debate_finished():
	action_queue.push(func():
		print("DEBATE OVER")
	)
