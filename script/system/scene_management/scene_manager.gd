extends Node

enum SceneLoadMode {
	REPLACE,
	ADDITIVE
}

func _ready():
	var node = get_tree().current_scene
	
	get_tree().current_scene = self
	node.reparent.call_deferred(self)

func load_scene(new_scene: String, scene_load_mode: SceneLoadMode = SceneLoadMode.REPLACE):
	if scene_load_mode == SceneLoadMode.REPLACE:
		for child in get_children():
			child.queue_free()
	
	var scene = load(new_scene).instantiate()
	add_child(scene)
