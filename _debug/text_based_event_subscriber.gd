@tool
extends EventSubscriber

class_name TextBasedEventSubscriber

@export var label: RichTextLabel

@export var title_font_size: int = 42
@export var dialogue_font_size: int = 28
@export var seconds_between_events: float = .1

@export var input_manager: InputManager
@export var dialogue_input_handler: InputHandler
var replaced_input_handler: InputHandler

@export_flags(
	"EVENT_START",
	"EVENT_END",
	"DIALOGUE",
	"ANIMATION",
	"TIMER") var type_filter: int = 31

var event_actions: Array[ActionLogActionType]
var current_title: String

var callable_queue: Queue = Queue.new()

var queue_is_running = false

func _ready():
	label.text = ""
	callable_queue.on_push = _run_queue

func _run_queue():
	if queue_is_running: return
	queue_is_running = true
	
	while callable_queue.size() > 0:
		await callable_queue.pop().call()
	
	queue_is_running = false

func _start_event(event: Event):
	if Engine.is_editor_hint():
		label.text = ""
	
	callable_queue.push(func():
		await _append_action_event(
			BBCode.font_size("\nStart %s[hr]" % Util.get_resource_name(event), title_font_size),
			ActionLogActionType.ActionType.EVENT_START
		)
		
		replaced_input_handler = input_manager.active_handler
		input_manager.active_handler = dialogue_input_handler
	)

func _end_event(event: Event):
	callable_queue.push(func():
		await _append_action_event(
			BBCode.font_size("End %s" % Util.get_resource_name(event), title_font_size),
			ActionLogActionType.ActionType.EVENT_END
		)
		
		input_manager.active_handler = replaced_input_handler
	)

func display_dialogue(dp: DialoguePayload):
	callable_queue.push(func():
		var actor_name =  dp.actor.to_upper()
		
		if current_title != actor_name:
			await _append_action_event(BBCode.font_size("\n" + actor_name + ":",title_font_size), ActionLogActionType.ActionType.TITLE)
		
		await _append_action_event(
			BBCode.font_size(dp.line, dialogue_font_size), 
			ActionLogActionType.ActionType.DIALOGUE,
			true
		)
	)

func play_animation(animation : String, actor : String, _overwrite_animation: bool, _await_animation: bool):
	callable_queue.push(func():
		var actor_name = actor.to_upper()
		actor_name = actor_name if actor_name else BBCode.center("Action Sequence")
		
		if current_title != actor_name:
			await _append_action_event(BBCode.font_size("\n" + actor_name + ":",title_font_size), ActionLogActionType.ActionType.TITLE)
		
		await _append_action_event(
			"Take Action: %s" % animation, 
			ActionLogActionType.ActionType.ANIMATION,
			true
		)
	)

func start_timer(seconds: float):
	callable_queue.push(func():
		await _append_action_event(
			"Wait %s seconds" % seconds, 
			ActionLogActionType.ActionType.TIMER
		)
	)

func _append_action_event(text: String, type: ActionLogActionType.ActionType, wait_for_seconds: bool = false):
	event_actions.append(ActionLogActionType.new(
		text,
		type
	))
	
	if type_filter & type || type == ActionLogActionType.ActionType.TITLE: 
		label.append_text(text)
		label.append_text("\n")
		if wait_for_seconds:
			await GlobalTimer.wait_for_seconds(seconds_between_events)
