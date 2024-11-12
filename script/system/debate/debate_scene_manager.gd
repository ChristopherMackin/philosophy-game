extends DebateSubscriber

@export var player : Character
@export var player_3d : DebateContestant3D

@export var computer : Character
@export var computer_3d : DebateContestant3D

@export var debate_settings : DebateSettings

@export var hand_ui : HandUI
@export var energy_ui : EnergyUI
@export var tops_board : TopsBoard3D
@export var draw_pile_ui : DrawPileUI

@export var event_manager : EventManager

var is_animation_locked := false

func _ready():
	super._ready()
	
	manager.init.call_deferred(player, computer, debate_settings)

func on_debate_start():
	energy_ui.update_amount(0)
	draw_pile_ui.update_amount(manager.player.deck.count)
	
func on_player_change(contestant : Contestant):
	print("%s's turn" % contestant.name)
	if contestant.character == player:
		hand_ui.update_hand(manager.player.hand)
		energy_ui.update_amount(contestant.current_energy)
		draw_pile_ui.update_amount(contestant.deck.count)
	await GlobalTimer.wait_for_seconds(1)
	
func on_top_played(top: Top, active_contestant : Contestant):
	if active_contestant.character == player:
		energy_ui.update_amount(active_contestant.current_energy)
		draw_pile_ui.update_amount(active_contestant.deck.count)
		await hand_ui.remove_card(top)
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

func query_event(concept : String):
	var query : Dictionary
	query["concept"] = concept
	query.merge(manager.get_debate_state())
	await event_manager.play_event(
		manager.event_factory.get_event(query)
	)
