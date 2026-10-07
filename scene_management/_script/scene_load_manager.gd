@tool
extends Node

class_name SceneLoadManager

signal on_scene_enter
signal on_scene_load

@export_category("Dependencies")
@export_group("Event")
@export var event_manager: EventManager
@export var event_factory: EventFactory
@export var blackboard: Blackboard
@export_group("Scene State")
@export var scene_animator: AnimationPlayer
@export var scene_state_nodes: Array[StateNode]
@export_group("Character Spawn")
@export var character_controller: CharacterBody3D
@export var spawn_locations: Array[Node3D]

@export_category("Scene State")
@export var rule_scene_loaders: Array[RuleSceneLoader]:
	set(val):
		rule_scene_loaders = Util.auto_populate_resource_array(rule_scene_loaders, val, RuleSceneLoader)

func _scene_added():
	(func(): on_scene_enter.emit()).call_deferred()
	if Engine.is_editor_hint(): return;
	
	var scene_loader: SceneLoader = DefaultSceneLoader.new()
	
	for rsl in rule_scene_loaders:
		if !rsl.rule || rsl.rule.check(Global.blackboard.get_query()): scene_loader = rsl.scene_loader
	
	scene_loader.set_scene_state(self)
	
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
