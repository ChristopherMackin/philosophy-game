extends NodeBasedDebateSubscriber

class_name DebateSceneManager

@export_group("Settings")
@export var blackboard: Blackboard
@export var event_factory: EventFactory:
	get:
		if !event_factory:
			event_factory = EventFactory.new()
		return event_factory
@export var event_manager : EventManager
@export var debate_settings : DebateSettings

@export_group ("Player")
@export var player : Character
@export var input_manager : InputManager
@export var selection_handler : InputHandler

@export_group ("Computer")
@export var computer : Character

@export_group("Player UI")
@export var hand_ui : HandUi
@export var hold_area_ui : HoldAreaUi
@export var energy_ui : RichTextLableUpdateEmitter
@export var draw_ui : RichTextLableUpdateEmitter
@export var discard_ui : RichTextLableUpdateEmitter

@export_group("Computer UI")
@export var computer_hand_ui : RichTextLableUpdateEmitter
@export var computer_energy_ui : RichTextLableUpdateEmitter
@export var computer_discard_ui : RichTextLableUpdateEmitter

@export_group("Game State UI")
@export var game_board: GameBoard3d
@export var turn_ui: RichTextLableUpdateEmitter
@export var lines_cleared_ui: RichTextLableUpdateEmitter

var is_animation_locked := false

func _ready():
	super._ready()

func start_debate():
	manager.start_debate(blackboard, player, computer, debate_settings)

func on_debate_start():
	await update_everything()
	await query_event(Const.Concept.ON_DEBATE_START)

func on_turn_start(contestant: Contestant):
	await update_everything()
	await query_event(Const.Concept.ON_TURN_START)
	
	if contestant.character_is(player): input_manager.active_handler = selection_handler


func on_turn_end(contestant: Contestant):
	await update_everything()
	if contestant.character_is(player): input_manager.active_handler = null
	await query_event(Const.Concept.ON_TURN_END)

func on_card_played(card: Card, contestant : Contestant):
	await update_everything()
	
	await query_event(Const.Concept.ON_PLAY)

func on_token_played(token: Token, suit: Suit, contestant : Contestant):	
	if contestant.character_is(computer):
		await GlobalTimer.wait_for_seconds(.5)
	
	await update_everything()

func on_card_hold_updated(card : Card, active_contestant : Contestant):
	await update_everything()
	await query_event(Const.Concept.ON_HOLD)

func on_lines_cleared(count : int):
	if lines_cleared_ui: lines_cleared_ui.update_label(str(count))

func on_actions_invoked(card : Card, action_type: CardAction.Type, contestant : Contestant):
	await update_everything()

func on_card_drawn(card : Card, contestant: Contestant):
	await update_everything()

func on_debate_finished():
	print("Debate Finished")
	await query_event(Const.Concept.ON_DEBATE_END)

func query_event(concept : Const.Concept):
	var query : Dictionary
	query["concept"] = concept
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(event_manager.blackboard.get_query())
	
	var event = event_factory.get_event(query)
	
	if !event: return
	
	if event.await_event:
		await event_manager.start_event(event)
	else:
		event_manager.start_event(event)

func update_everything():
	await update_player_ui()
	await update_computer_ui()
	await update_board_statue_ui()

func update_player_ui():
	if hand_ui: await hand_ui.update_hand(manager.player.hand)
	if hold_area_ui: await hold_area_ui.set_hold_card(manager.player.held_card.get_card_at_index(0))
	if energy_ui: await energy_ui.update_label(str(manager.player.current_energy) + "/" + str(manager.player.energy_level))
	if draw_ui: await draw_ui.update_label(str(manager.player.draw_pile.size()))
	if discard_ui: await discard_ui.update_label(str(manager.player.discard_pile.size()))


func update_computer_ui():
	if computer_hand_ui: await computer_hand_ui.update_label(str(manager.computer.hand.size()))
	if computer_energy_ui: await computer_energy_ui.update_label(str(manager.computer.current_energy))
	if computer_discard_ui: await computer_discard_ui.update_label(str(manager.computer.discard_pile.size()))

func update_board_statue_ui():
	if game_board: game_board.update_token_tracks(manager.suit_track_dictionary)
	if turn_ui: await turn_ui.update_label(str(manager.current_round))
	if lines_cleared_ui: lines_cleared_ui.update_label(str(manager.lines_cleared))
