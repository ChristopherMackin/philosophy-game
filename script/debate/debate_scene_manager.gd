extends DebateSubscriber

@export_group("Settings")
@export var event_manager : EventManager
@export var debate_settings : DebateSettings

@export_group ("Player")
@export var player : Character
@export var player_3d : DebateContestant3D
@export var selection_manager : SelectionManager

@export_group ("Computer")
@export var computer : Character
@export var computer_3d : DebateContestant3D

@export_group("Player UI")
@export var board : Board3D
@export var hand_ui : HandUI
@export var energy_ui : EnergyUI
@export var hold_area_ui : HoldAreaUI
@export var draw_pile_ui : DrawPileUI

@export_group("Computer UI")
@export var computer_energy_ui : EnergyUI
@export var computer_hand_ui : HandCountUI

var is_animation_locked := false

func _ready():
	super._ready()
	manager.init.call_deferred(player, computer, debate_settings)

func on_debate_start():
	await update_everything()

func on_player_change(contestant : Contestant):	
	await update_everything()

	selection_manager.pause_input()

func on_turn_start(_contestant: Contestant):
	await update_everything()

func on_turn_end(_contestant: Contestant):
	await update_everything()

func on_card_played(card: Card, contestant : Contestant):
	await GlobalTimer.wait_for_seconds(.3)
	
	await update_everything()
	
	await query_event("on_card_played")

func on_token_played(token: Token, parent: Card, contestant : Contestant):	
	await update_everything()

func on_card_hold_updated(card : Card, active_contestant : Contestant):
	await update_everything()

func on_lines_cleared(count : int):
	await board.clear_row(count)

func on_actions_invoked(card : Card, action_type: Constants.ActionType, contestant : Contestant):
	await update_everything()

func on_card_drawn(_card : Card, _contestant: Contestant):
	await update_everything()

func on_debate_finished():
	print("Debate Finished")
	get_tree().quit()

func query_event(concept : String):
	var query : Dictionary
	query["concept"] = concept
	query.merge(manager.blackboard.get_query())
	
	var event = manager.computer.debate_event_factory.get_event(query)
	
	if !event: return
	
	if event.await_event:
		await event_manager.start_event(event)
	else:
		event_manager.start_event(event)

func update_everything():
	await update_board()
	await update_player_ui()
	await update_computer_ui()

func update_board():
	if !manager.active_contestant: return
	
	var active_contestant = "player" if manager.active_contestant.character_is(player) else "computer"
	await board.update_board_3d(manager.suit_track_dictionary, active_contestant)

func update_player_ui():
	await hand_ui.update_hand(manager.player.hand)
	await energy_ui.update_amount(manager.player.current_energy)
	await hold_area_ui.set_hold_card(manager.player.held_card)
	await draw_pile_ui.update_amount(manager.player.draw_pile.size())

func update_computer_ui():
	await computer_hand_ui.update_amount(manager.computer.hand.size())
	await computer_energy_ui.update_amount(manager.computer.current_energy)
