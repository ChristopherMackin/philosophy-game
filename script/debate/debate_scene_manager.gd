extends DebateSubscriber

@export_group("Settings")
@export var debate_settings : DebateSettings
@export var event_manager : EventManager
@export var selection_manager : SelectionManager

@export_group ("Player")
@export var player : Character
@export var player_3d : DebateContestant3D

@export_group ("Computer")
@export var computer : Character
@export var computer_3d : DebateContestant3D

@export_group("Player UI")
@export var tops_board : TopsBoard3D
@export var hand_ui : HandUI
@export var energy_ui : EnergyUI
@export var draw_pile_ui : DrawPileUI

@export_group("Computer UI")
@export var computer_energy_ui : EnergyUI
@export var computer_hand_ui : HandCountUI

var is_animation_locked := false

func _ready():
	super._ready()
	
	manager.init.call_deferred(player, computer, debate_settings)

func on_debate_start():
	pass
	
func on_player_change(contestant : Contestant):
	print("%s's turn" % contestant.name)
	if contestant.character == player:
		selection_manager.continue_ui_input()
	else:
		selection_manager.pause_ui_input()
	
	await GlobalTimer.wait_for_seconds(1)
	
func on_top_played(top: Top, active_contestant : Contestant):
	if active_contestant.character == player:
		await player_3d.play_top(top)
	else:
		await computer_3d.play_top(top)
	
	await query_event("on_top_played")

func on_score_updated(pose_score_dictionary : Dictionary):
	pass

func on_lines_cleared(count : int):
	await tops_board.clear_row(count)

func on_debate_finished():
	print("Debate Finished")

func on_hand_updated(contestant : Contestant):
	if contestant.character == player:
		hand_ui.update_hand(contestant.hand)
	elif contestant.character == computer:
		computer_hand_ui.update_amount(contestant.hand.size())

func on_energy_updated(contestant : Contestant):
	if contestant.character == player:
		energy_ui.update_amount(contestant.current_energy)
	elif contestant.character == computer:
		computer_energy_ui.update_amount(contestant.current_energy)

func on_deck_updated(contestant : Contestant):
	if contestant.character == player:
		draw_pile_ui.update_amount(manager.player.deck.count)

func query_event(concept : String):
	var query : Dictionary
	query["concept"] = concept
	query.merge(manager.get_debate_state())
	
	var event = manager.event_factory.get_event(query)
	
	if !event: return
	
	if event.await_event:
		await event_manager.start_event(event)
	else:
		event_manager.start_event(event)
