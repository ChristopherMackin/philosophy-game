@tool
extends SceneEventManager

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

@export var inputs: Dictionary:
	get:
		if !manager or !manager.current_task or !manager.current_task.action: return {}
		return manager.current_task.inputs
	set(val):
		if !manager or !manager.current_task or !manager.current_task.action: return
		
		manager.current_task.inputs = val
		ResourceSaver.save(manager.current_task)

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

func add_status_effect(_effect: StatusEffect, _which_player: Const.Player):
	print("Status Effect Added: " + _effect.name)

func remove_status_effect(_effect: StatusEffect, _which_player: Const.Player):
	print("Status Effect Removed: " + _effect.name)

func get_event_using_data():
	var query : Dictionary
	query["concept"] = concept
	query["active_contestant"] = "player" if active_contestant == Const.Player.HUMAN else "computer"
	query["current_round"] = current_round
	query["current_suit"] = card_history[0].suit if card_history.size() > 0 else null
		
	var history: Array[Card]
	for base in self.card_history:
		if !base: continue
		history.append(Card.new(base, null))
	
	query["card_history"] = card_history
	
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(manager.blackboard.get_query())
	
	event = event_factory.get_event(query)
