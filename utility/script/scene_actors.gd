@tool
extends Node

var _current_actors: Array[Actor]

func _ready():
	_refresh_actor_list()
	Util.optional_connect(SceneManager, "on_scene_unloaded", _refresh_actor_list)
	Util.optional_connect(SceneManager, "on_scene_loaded", _refresh_actor_list)

func _refresh_actor_list():
	_current_actors.clear()
	_current_actors.assign(get_tree().root.find_children("*", "Actor", true, false))
	
	for actor in _current_actors:
		if _current_actors.filter(func(x): return actor.actor_name == x.actor_name).size() > 1:
			push_error("ERROR: Two actors share a name -> \n Node: %s \n Actor Name: %s" % [actor.name, actor.actor_name])

func get_actors() -> Array[Actor]:
	if Engine.is_editor_hint(): _refresh_actor_list()
	
	return _current_actors

func save_actors_state():
	Global.blackboard.add()

func get_actors_state():
	pass
