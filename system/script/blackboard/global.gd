extends Node

@export var blackboard : Blackboard

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		await Global.create_timer(.01)
		get_tree().quit()

var actors: Array[Actor]:
	get():
		if Engine.is_editor_hint(): _refresh_actor_list()
		return actors

var state_nodes: Array[StateNode]:
	get():
		var state_nodes: Array[StateNode]
		state_nodes.assign(get_tree().root.find_children("*", "StateNode", true, false))
		return state_nodes

func create_timer(seconds : float):
	await get_tree().create_timer(seconds).timeout

func process_frame():
	await get_tree().process_frame

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
	get_tree().set_auto_accept_quit(false)
	_refresh_actor_list()
	Util.optional_connect(SceneManager, "on_scene_unloaded", _refresh_actor_list)
	Util.optional_connect(SceneManager, "on_scene_loaded", _refresh_actor_list)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _refresh_actor_list():
	actors.clear()
	actors.assign(get_tree().root.find_children("*", "Actor", true, false))
	
	for actor in actors:
		if actors.filter(func(x): return actor.actor_name == x.actor_name).size() > 1:
			push_error("ERROR: Two actors share a name -> \n Node: %s \n Actor Name: %s" % [actor.name, actor.actor_name])
