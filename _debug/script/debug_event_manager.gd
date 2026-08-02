@tool
extends EventSubscriber

class_name DebugEventManager

@export_tool_button("Start Event", "Play") var btn_start:
	get: return start_event
@export_tool_button("Continue", "DebugContinue") var btn_continue:
	get: return _continue
@export_tool_button("Skip", "PlayStart") var btn_skip: 
	get: return _skip
@export_tool_button("Cancel Event", "Stop") var btn_cancel:
	get: return cancel_event

@export_category("Event")
@export var event: Event
@export var event_factory: EventFactory:
	set(val):
		event_factory = val
		notify_property_list_changed()

@export_group("Debate Data")
@export var concept: Const.Concept
@export var active_contestant: Const.Player
@export var card_history: Array[CardBase]
@export var current_round: int

@export var blackboard: Blackboard:
	get: return manager.blackboard if manager else null

@export_group("")

@export_tool_button("Get Factory Event", "Animation") var btn_event_factory:
	get: return get_event_using_data

func _validate_property(property: Dictionary):
	if property.name == "btn_start" and (!manager or manager.current_task):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["btn_cancel", "btn_continue", "btn_skip"] and (!manager or !manager.current_task):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name == "btn_event_factory" and !event_factory:
		property.usage = PROPERTY_USAGE_NO_EDITOR

@export_category("Task")

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY) var task_type: String:
	get():
		if !manager or !manager.current_task or !manager.current_task.action: return ""
		return manager.current_task.action.get_script().resource_path.get_file()

@export var inputs: Array:
	get:
		if !manager or !manager.current_task or !manager.current_task.action: return []
		return manager.current_task.inputs
	set(val):
		if !manager or !manager.current_task or !manager.current_task.action: return
		
		manager.current_task.inputs = val
		ResourceSaver.save(manager.current_task)

@export_group("Dependencies")
@export var debate_manager: DebateManager

@export var scene_animator_handler: AnimationHandler
@export var actors: Array[Actor]

@export var default_dialogue_area: DialogueArea

var await_event: bool

signal continue_dialogue
signal skip

var _previous_task: Task

func _ready() -> void:
	if not Engine.is_editor_hint():
		queue_free()

func _process(delta) -> void:
	if !manager: return
	if _previous_task != manager.current_task:
		notify_property_list_changed()
	
	_previous_task = manager.current_task

func start_event():
	manager.start_event(event)
	notify_property_list_changed()

func cancel_event():
	await manager.cancel_current_event()
	notify_property_list_changed()

func _continue(): 
	continue_dialogue.emit()
	notify_property_list_changed()

func _skip(): 
	continue_dialogue.emit() 
	skip.emit()
	notify_property_list_changed()
	
func _start_event(event: Event):
	await_event = event.await_event
	if !await_event: return

func _end_event(event: Event):
	if !await_event: return

func display_dialogue(line : String, actor : String, await_input : bool, seconds_before_close : float):
	dialogue_canceled = false
	
	var current_actor: Actor = null
	
	if actor != "":
		var index = get_actor_index(actor)
		if index < 0:
			push_error("MISSING LINE \nACTOR: \"%s\"\n LINE: %s" % [actor, line])
			return
		current_actor = actors[index]
	
	if !default_dialogue_area && !current_actor.dialogue_area_override: return
	
	var dialogue_area: DialogueArea = default_dialogue_area
	
	if current_actor:
		if current_actor.dialogue_area_override:
			dialogue_area = current_actor.dialogue_area_override
		current_actor.focus_actor(true)
		current_actor.is_talking = true
		dialogue_area.set_text(line, current_actor.display_name)
	
	else:
		dialogue_area.set_text(line)
	
	dialogue_area.visible = true
	
	await Util.await_any([
		func(): await dialogue_area.on_dialogue_finished,
		func(): await skip,
		func(): await _on_dialogue_canceled
	])
	
	if current_actor:
		current_actor.is_talking = false
	
	if dialogue_canceled: return
	
	dialogue_area.skip_to_the_end()
	
	var continue_trigger: Callable
	
	if await_event && await_input: continue_trigger = func(): await continue_dialogue
	else: continue_trigger = func(): await GlobalTimer.wait_for_seconds(seconds_before_close)
	
	await Util.await_any([
		continue_trigger,
		func(): await _on_dialogue_canceled
	])
	
	if dialogue_canceled: return
	
	dialogue_area.visible = false
	
	if current_actor:
		current_actor.focus_actor(false)

func cancel_dialogue(actor):
	var dialogue_area = default_dialogue_area
	
	if actor != "":
		var index = get_actor_index(actor)
		var current_actor = actors[index]
		if current_actor.dialogue_area_override:
			dialogue_area = current_actor.dialogue_area_override

		current_actor.focus_actor(false)
	
		dialogue_area.visible = false
	
	dialogue_canceled = true
	_on_dialogue_canceled.emit()

func play_animation(animation : String, actor : String, overwrite_animation: bool, await_animation : bool):
	var parent
	var animation_handler: AnimationHandler
	
	if actor != "":
		var index = get_actor_index(actor)
		
		if index < 0:
			return
			
		parent = actors[index]
		animation_handler = parent.get_node_or_null(NodePath("AnimationHandler"))

	
	else:
		animation_handler = scene_animator_handler
		
	animation_handler.start_animation(animation)
	
	if await_animation:
		var finished_animation = await animation_handler.on_animation_finished
		while finished_animation != animation:
			finished_animation = await animation_handler.on_animation_finished
			print("finished_animation")

func cancel_animation(actor):
	var parent
	var animation_handler: AnimationHandler
	
	if actor != "":
		var index = get_actor_index(actor)
		
		if index < 0:
			return
			
		parent = actors[index]
		animation_handler = parent.get_node_or_null(NodePath("AnimationHandler"))

	
	else:
		animation_handler = scene_animator_handler
	
	animation_handler.cancel_animation()

func get_actor_index(actor_name : String) -> int:
	return actors.map(func(x): return x.actor_name.to_snake_case()).find(actor_name.to_snake_case())

func add_status_effect(_effect: StatusEffect, _which_player: Const.Player):
	print("Status Effect Added: " + _effect.name)

func remove_status_effect(_effect: StatusEffect, _which_player: Const.Player):
	print("Status Effect Removed: " + _effect.name)

func get_event_using_data():
	var query : Dictionary
	query["concept"] = concept
	query["active_contestant"] = "player" if active_contestant == Const.Player.HUMAN else "computer"
	query["current_round"] = current_round
	
	var card_history: Array[Card]
	for base in self.card_history:
		if !base: continue
		card_history.append(Card.new(base, null))
	
	query["card_history"] = card_history
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(manager.blackboard.get_query())
	
	event = event_factory.get_event(query)
