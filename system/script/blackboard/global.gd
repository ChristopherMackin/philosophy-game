extends Node

@export var blackboard : Blackboard
var actors: Array[Actor]:
	get():
		if Engine.is_editor_hint(): _refresh_actor_list()
		return actors


func wait_for_seconds(seconds : float):
	await get_tree().create_timer(seconds).timeout

func _ready():
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

func save_collision_state():
	var collision_array: Array[CollisionObject3D]
	collision_array.assign(get_tree().root.find_children("*", "CollisionObject3D", true, false))
	
	var collision_state: Array[Node3dState]
	collision_state.assign(collision_array.map(func(c: CollisionObject3D): return Node3dState.get_collision_state_from_collision_3d(c)))
	blackboard.add_flag(Flag.COLLISION_STATE, collision_state)

func load_collision_state():
	if !blackboard.has_flag(Flag.COLLISION_STATE): return
	
	var collision_state: Array[Node3dState]
	collision_state.assign(blackboard.get_flag_value(Flag.COLLISION_STATE))
	
	var collision_array: Array[CollisionObject3D]
	collision_array.assign(get_tree().root.find_children("*", "CollisionObject3D", true, false))
	
	(func():
		for state in collision_state:
			var node = get_node(state.node_path)
			if ! node: continue
			state.set_state(node)
	).call_deferred()
