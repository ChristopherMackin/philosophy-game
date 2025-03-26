extends Node

class_name SelectionManager

@export_group("Player")
@export var player_brain : PlayerBrain

@export_group("Focus Groups")
@export var idle_focus_group : FocusGroup
@export var hand_ui_focus_group : FocusGroup
@export var play_area_selector_focus_group : FocusGroup
@export var card_selector_focus_group : FocusGroup
@export var suit_selector_focus_group : FocusGroup

@export_group("Focus Clear")
@export var ui_clear_focus_node : Control

@export_group("Selectors")
@export var play_area_selector : PlayAreaSelector
@export var card_selector : CardSelector
@export var suit_selector : SuitSelector

var active_focus_group : FocusGroup

var focused_node : Control:
	get: return active_focus_group.focused_node

func _ready():
	idle_focus_group.focused_node = ui_clear_focus_node
	player_brain.on_selection_requested.connect(on_selection_requested)
	get_viewport().gui_focus_changed.connect(on_focus_changed)

func on_focus_changed(node : Node):
	if node is Control:
		node.grab_focus()
	else: ui_clear_focus_node.grab_focus()
	
	active_focus_group.focus(node)

func _unhandled_input(event):
	if event.is_action_pressed("action_1"):
		active_focus_group.select()
	if event.is_action_pressed("action_2"):
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
	else:
		card_selector.open_selector(request.options, request.visible_to_player, request.action)
		set_focus_group(card_selector_focus_group)

func pause_input():
	set_focus_group(idle_focus_group)

func set_focus_group(focus_group : FocusGroup):
	if active_focus_group:
		active_focus_group.on_focus_changed.disconnect(on_focus_changed)
		active_focus_group.on_group_deselected.emit()
	
	active_focus_group = focus_group
	active_focus_group.on_focus_changed.connect(on_focus_changed)
	active_focus_group.on_group_selected.emit()
	
	on_focus_changed(active_focus_group.focused_node)
