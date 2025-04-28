extends Node

enum SceneLoadMode {
	REPLACE,
	ADDITIVE
}

const SCENE_MANIFEST = preload("res://scene_manifest.tres")

func _ready():
	var node = get_tree().current_scene
	
	get_tree().current_scene = self
	node.reparent.call_deferred(self)

func load_scene(scene_name: String, scene_load_mode: SceneLoadMode = SceneLoadMode.REPLACE) -> bool:
	var scene_index = SCENE_MANIFEST.scene_list.find_custom(func(x): return Util.get_resource_name(x) == scene_name)
	if scene_index == -1: return false
	
	if scene_load_mode == SceneLoadMode.REPLACE:
		for child in get_children():
			child.queue_free()
	
	var scene = SCENE_MANIFEST.scene_list[scene_index].instantiate()
	add_child(scene)
	
	return true

func load_scene_by_index(scene_index: int, scene_load_mode: SceneLoadMode = SceneLoadMode.REPLACE):
	if scene_index <0 || scene_index >= SCENE_MANIFEST.scene_list.size(): return false
	
	if scene_load_mode == SceneLoadMode.REPLACE:
		for child in get_children():
			child.queue_free()
	
	var scene = SCENE_MANIFEST.scene_list[scene_index].instantiate()
	add_child(scene)
	
	return true
