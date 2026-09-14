@tool
extends EventSubscriber

class_name TextBasedEventSubscriber

@export var label: RichTextLabel

@export var title_font_size: int = 42
@export var dialogue_font_size: int = 28

@export var input_manager: InputManager
@export var dialogue_input_handler: InputHandler
var replaced_input_handler: InputHandler

var await_event: bool

signal continue_dialogue
signal skip

@export_flags(
	"EVENT_START",
	"EVENT_END",
	"DIALOGUE",
	"ANIMATION",
	"TIMER") var type_filter: int = 31

var event_actions: Array[ActionLogActionType]
var current_title: String

func _ready():
	label.text = ""
	dialogue_input_handler.on_handle_input.connect(_handle_input)

func _handle_input(_delta, input):
	if input.is_action_just_pressed("action_1"):
		continue_dialogue.emit()
	if input.is_action_just_pressed("cancel"):
		continue_dialogue.emit()
		skip.emit()

func _start_event(event: Event):
	if Engine.is_editor_hint():
		label.text = ""
	
	_append_action_event(
		BBCode.font_size("\nStart %s[hr]" % Util.get_resource_name(event), title_font_size),
		ActionLogActionType.ActionType.EVENT_START
	)
	
	await_event = event.await_event
	if !await_event: return
	
	replaced_input_handler = input_manager.active_handler
	input_manager.active_handler = dialogue_input_handler

func _end_event(event: Event):
	_append_action_event(
		BBCode.font_size("[hr]", title_font_size),
		ActionLogActionType.ActionType.EVENT_END
	)
	
	input_manager.active_handler = replaced_input_handler

func display_dialogue(dp: DialoguePayload):
	dialogue_canceled = false
	
	_append_action_event(
		BBCode.font_size(dp.line, dialogue_font_size),
		ActionLogActionType.ActionType.DIALOGUE
	)
	
	var continue_trigger: Callable
	
	if await_event && dp.await_input: continue_trigger = func(): await continue_dialogue
	else: continue_trigger = func(): await GlobalTimer.wait_for_seconds(dp.close_timer)
	
	await Util.await_any([
		continue_trigger,
		func(): await _on_dialogue_canceled
	])
	
	if dialogue_canceled: return

func cancel_dialogue(actor):
	dialogue_canceled = true
	_on_dialogue_canceled.emit()

func play_animation(animation : String, actor : String, _overwrite_animation: bool, _await_animation: bool):
	var actor_name = actor.to_upper()
	actor_name = actor_name if actor_name else BBCode.center("Action Sequence")
	
	if current_title != actor_name:
		await _append_action_event(BBCode.font_size("\n" + actor_name + ":",title_font_size), ActionLogActionType.ActionType.TITLE)
	
	_append_action_event(
		"Take Action: %s" % animation, 
		ActionLogActionType.ActionType.ANIMATION,
	)

func start_timer(seconds: float):
	_append_action_event(
		"Wait %s seconds" % seconds, 
		ActionLogActionType.ActionType.TIMER
	)
	
	await GlobalTimer.wait_for_seconds(seconds)

func _append_action_event(text: String, type: ActionLogActionType.ActionType):
	event_actions.append(ActionLogActionType.new(
		text,
		type
	))
	
	if type_filter & type || type == ActionLogActionType.ActionType.TITLE: 
		label.append_text(text)
		label.append_text("\n")
