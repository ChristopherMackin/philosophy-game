extends Node

class_name SceneLoadManager

signal on_scene_load

@export_group("Dependencies")
@export var event_manager: EventManager
@export var blackboard: Blackboard
@export var event_factory: EventFactory
@export var scene_animator: AnimationPlayer

@export_group("Room State")
@export var scene_loader_factory: SceneLoaderFactory

func _ready():
	if Engine.is_editor_hint(): return;
	
	var scene_loader: SceneLoader 
	
	if scene_loader_factory:
		scene_loader = scene_loader_factory.get_scene_loader(blackboard.get_query())
	
	if scene_loader: scene_loader.set_scene_state(self)
	
	await query_event
	
	(func(): on_scene_load.emit()).call_deferred()
	queue_free()

func query_event():
	var query : Dictionary
	query[Flag.name(Flag.CONCEPT)] = Const.Concept.ON_SCENE_ENTER
	query.merge(blackboard.get_query())
	
	var event = event_factory.get_event(query)
	
	if !event: return
	
	await event_manager.start_event(event, blackboard)
