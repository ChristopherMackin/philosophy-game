extends Node

@export var blackboard: Blackboard
@export var event_manager: EventManager
@export var event_factory: EventFactory

func query_event(node: Node3D):
	var query : Dictionary
	query["concept"] = Const.Concept.ON_EVENT_TRIGGER_INVOKED
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(blackboard.get_query())
	
	var event = event_factory.get_event(query)
	
	if !event: return
	
	if event.await_event:
		await event_manager.start_event(blackboard, event)
	else:
		event_manager.start_event(blackboard, event)
