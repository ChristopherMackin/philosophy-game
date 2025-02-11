extends DebateSubscriber

@export_group("Settings")
@export var debate_settings : DebateSettings
@export var event_manager : EventManager

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
	selection_manager.pause_input()
	
func on_card_played(card: Card, active_contestant : Contestant):
	await query_event("on_card_played")

func on_score_updated(suit_score_dictionary : Dictionary):
	pass

func on_lines_cleared(count : int):
	await board.clear_row(count)

func on_debate_finished():
	print("Debate Finished")
	get_tree().quit()

func on_board_updated(suit_track_dictionary : Dictionary):
	var active_contestant = "player" if manager.active_contestant.character == player else "computer"
	await board.update_board_3d(suit_track_dictionary, active_contestant)

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
		draw_pile_ui.update_amount(manager.player.get_deck_count())

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
