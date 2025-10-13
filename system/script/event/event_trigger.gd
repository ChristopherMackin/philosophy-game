extends Node

class_name EventTrigger

@export var event_manager: EventManager
@export var event_factory: EventFactory

func query_event():
	var query : Dictionary
	query["concept"] = Const.Concept.ON_EVENT_TRIGGER_INVOKED
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(event_manager.blackboard.get_query())
	
	var event = event_factory.get_event(query)
	
	if !event: return
	
	if event.await_event:
		await event_manager.start_event(event)
	else:
		event_manager.start_event(event)
