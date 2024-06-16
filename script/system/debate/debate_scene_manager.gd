extends DebateSubscriber

@export var debate_settings : DebateSettings
@export var player : Character
@export var computer : Character

@export var debate_start_animator : AwaitAnimator
@export var computer_hand_ui : ComputerHandUI
@export var player_hand_ui : PlayerHandUI
@export var energy_pool : EnergyPool
@export var draw_pile_ui : DrawPileUI
@export var event_manager : EventManager

var is_animation_locked := false

func _ready():
	super._ready()
	#set up topic/pose score board here
	
	manager.init(player, computer)

func on_debate_start(starting_card : Card):
	await query_event("on_debate_start")
	var player_hand = manager.player.hand.duplicate();
	var deck_count := manager.player.deck.count
	var pose = manager.current_pose
	
	player_hand_ui.enabled = false;
	energy_pool.set_energy(manager.player.current_energy)
	draw_pile_ui.set_count(deck_count)
	player_hand_ui.update_card_array(player_hand, pose)
	
	await Util.await_all([
		func(): await debate_start_animator.play_await("debate_start"),
		func(): await computer_hand_ui.on_card_played(starting_card)
	])

func on_player_change(contestant : Contestant):
	match contestant.character:
		player:
			player_hand_ui.enabled = true;
			energy_pool.set_energy(manager.player.current_energy)
			player_hand_ui.update_card_array(manager.player.hand.duplicate(), manager.current_pose)
		computer:
			player_hand_ui.enabled = false;
			draw_pile_ui.set_count(manager.player.deck.count)

func on_card_played(card: Card, active_contestant : Contestant):
	match active_contestant.character:
		player:
			energy_pool.set_energy(active_contestant.current_energy)
			await player_hand_ui.on_card_played(card)
			player_hand_ui.update_card_array(manager.player.hand.duplicate(), manager.current_pose)
			draw_pile_ui.set_count(manager.player.deck.count)
		computer:
			await get_tree().create_timer(.7).timeout
			await computer_hand_ui.on_card_played(card)
	
	await query_event("on_card_played")

func on_action_taken(action : CardAction, is_positive : bool):	
	energy_pool.set_energy(manager.player.current_energy)
	draw_pile_ui.set_count(manager.player.deck.count)
	player_hand_ui.update_card_array(manager.player.hand.duplicate(), manager.current_pose)

func pose_score_updated(pose : Pose, score : int):
	pass

func on_debate_finished():
	await query_event("on_debate_finished")

func query_event(concept : String):
	var query : Dictionary
	query["concept"] = concept
	query.merge(manager.get_debate_state())
	await event_manager.play_event(
		manager.event_factory.get_event(query)
	)
