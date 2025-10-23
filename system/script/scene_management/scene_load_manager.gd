extends Node

class_name SceneLoadManager

signal on_scene_load
signal _event_finished

@export var event_manager: EventManager
@export var blackboard: Blackboard
@export var event_factory: EventFactory

func _ready():
	blackboard.expire(blackboard.ExpirationToken.ON_SCENE_ENTER)
	SceneManager.on_scene_unload.connect(func(): blackboard.expire(blackboard.ExpirationToken.ON_SCENE_EXIT), CONNECT_ONE_SHOT)
	
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
