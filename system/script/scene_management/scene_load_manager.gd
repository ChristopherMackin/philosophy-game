@tool
extends Node

class_name SceneLoadManager

signal on_scene_load
signal _event_finished

@export_group("Dependencies")
@export var event_manager: EventManager
@export var blackboard: Blackboard
@export var event_factory: EventFactory

@export_group("Room State")
@export var scene_animator: AnimationPlayer
@export var ordered_room_states: Array[StringCriterion]:
	set(val):
		ordered_room_states = Util.auto_populate_resource_array(ordered_room_states, val, StringCriterion)

func _ready():
	set_room_state()
	set_player_spawn()
	
	if blackboard:
		event_manager.blackboard = blackboard
	
	if event_factory:
		query_event.call_deferred()
		await _event_finished
	
	on_scene_load.emit()

func query_event():
	var query : Dictionary
	query["concept"] = Const.Concept.ON_SCENE_ENTER
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(event_manager.blackboard.get_query())
	
	var event = event_factory.get_event(query)
	
	if event:
		if event.await_event:
			await event_manager.start_event(event)
		else:
			event_manager.start_event(event)
	
	_event_finished.emit.call_deferred()

func set_room_state():
	if !scene_animator: return
	
	var query: Dictionary
	query = GlobalBlackboard.blackboard.get_query()
	query.merge(blackboard.get_query())
	
	for state in ordered_room_states:
		if state.criterion.check(query):
			scene_animator.play(state.string)
			break

func set_player_spawn():
	pass
