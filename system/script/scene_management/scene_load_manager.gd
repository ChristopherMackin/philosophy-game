extends Node

class_name SceneLoadManager

@export var event_manager: EventManager
@export var blackboard: Blackboard
@export var event_factory: EventFactory

func _ready():
	if blackboard:
		event_manager.blackboard = blackboard
	
	if event_factory:
		query_event.call_deferred()

func query_event():
	var query : Dictionary
	query["concept"] = Const.Concept.ON_SCENE_ENTER
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(event_manager.blackboard.get_query())
	
	var event = event_factory.get_event(query)
	
	if !event: return
	
	if event.await_event:
		await event_manager.start_event(event)
	else:
		event_manager.start_event(event)
