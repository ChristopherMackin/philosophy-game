extends Node

class_name SelectionManager

@export_group("Input")
@export var input_handler: InputHandler

@export_group("Player")
@export var player_brain : PlayerBrain

@export_group("Focus Groups")
@export var hand_ui_focus_group : FocusGroup
@export var play_area_selector_focus_group : FocusGroup
@export var card_selector_focus_group : FocusGroup
@export var suit_selector_focus_group : FocusGroup

@export_group("Selectors")
@export var play_area_selector : PlayAreaSelector
@export var card_selector : CardSelector
@export var suit_selector : SuitSelector

var active_focus_group : FocusGroup

var focused_node : Control:
	get: return active_focus_group.focused_node

func _ready():
	player_brain.on_selection_requested.connect(on_selection_requested)
	input_handler.on_handle_input.connect(_handle_input)
	input_handler.on_handler_selected.connect(_on_handler_selected)
	input_handler.on_handler_deselected.connect(_on_handler_deselected)
	

func _on_handler_selected():
	if active_focus_group:
		active_focus_group.on_group_selected()

func _on_handler_deselected():
	if active_focus_group:
		active_focus_group.on_group_deselected()

func _handle_input(_delta, input):
	if input.is_action_just_pressed("up"):
		active_focus_group.focus_top()
	elif input.is_action_just_pressed("down"):
		active_focus_group.focus_bottom()
	elif input.is_action_just_pressed("left"):
		active_focus_group.focus_left()
	elif input.is_action_just_pressed("right"):
		active_focus_group.focus_right()
	
	if input.is_action_just_pressed("action_1"):
		active_focus_group.select()
	if input.is_action_just_pressed("action_2"):
		active_focus_group.select("hold")

func on_selection_requested(request : SelectionRequest):
	if request.type == Const.SelectionType.SUIT:
		focus_suit_selector(request)
	else:
		focus_card_selector(request)

func focus_suit_selector(request : SelectionRequest):
	suit_selector.open_selector(request.options)
	set_focus_group(suit_selector_focus_group)

func focus_card_selector(request : SelectionRequest):
	if request.action == Const.SelectionAction.PLAY:
		set_focus_group(hand_ui_focus_group)
	elif request.type == Const.SelectionType.TOKEN:
		play_area_selector.open_selector(request.options)
		set_focus_group(play_area_selector_focus_group)
	elif request.type == Const.SelectionType.SUIT:
		suit_selector.open_selector(request.options, request.visible_to_player)
		set_focus_group(suit_selector_focus_group)
	else:
		card_selector.open_selector(request.options, request.visible_to_player, request.action, request.amount, request.min_amount)
		set_focus_group(card_selector_focus_group)

func set_focus_group(focus_group : FocusGroup):
	if active_focus_group: active_focus_group.on_group_deselected()
	
	active_focus_group = focus_group
	
	if active_focus_group: active_focus_group.on_group_selected()
