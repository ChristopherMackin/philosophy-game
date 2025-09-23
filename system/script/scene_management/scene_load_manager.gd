extends Node

class_name SceneLoadManager

@export var spawn_locations: Array[Node3D]
@export var joy: Node3D
@export var event_manager: EventManager
@export var blackboard: Blackboard
@export var event_factory: EventFactory

# Called when the node enters the scene tree for the first time.
func _ready():
	if event_factory:
		query_event.call_deferred()
	#var index = GlobalBlackboard.blackboard.get_value("spawn_index")
	#if index != null && index < spawn_locations.size():
	#joy.position = spawn_locations[index].position

func query_event():
	var query : Dictionary
	query["concept"] = Const.Concept.ON_SCENE_ENTER
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(blackboard.get_query())
	
	var event = event_factory.get_event(query)
	
	if !event: return
	
	if event.await_event:
		await event_manager.start_event(blackboard, event)
	else:
		event_manager.start_event(blackboard, event)
