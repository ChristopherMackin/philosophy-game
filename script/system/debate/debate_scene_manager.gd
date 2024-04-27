extends DebateSubscriber

@export var debate_settings : DebateSettings
@export var player : Character
@export var computer : Character

@onready var debate_profile : DebateProfileUI = $CharacterProfile
@onready var score_board : ScoreBoard = $ScoreBoard
@onready var player_hand_ui : PlayerHandUI = $PlayerHand
@onready var computer_hand_ui : ComputerHandUI = $ComputerHand
@onready var debate_start_animator : AwaitAnimator = $DebateStartGraphic/AnimationPlayer
@onready var energy_pool : EnergyPool = $EnergyPool
@onready var draw_pile_ui : DrawPileUI = $Draw

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
		await Util.await_all([
			func(): await debate_start_animator.play_await("debate_start"),
			func(): await computer_hand_ui.on_card_played(starting_card)
		])
		
		print("TEST")
	)

func on_player_change(contestant : Contestant):
	pass

func on_card_played(card: Card, active_contestant : Contestant):
	pass

func on_action_taken(action : CardAction, is_positive : bool):
	pass

func topic_score_updated(topic : Topic, score : int):
	pass

func on_debate_finished():
	pass
