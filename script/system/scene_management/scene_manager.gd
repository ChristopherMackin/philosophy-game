extends Node

enum SceneLoadMode {
	REPLACE,
	ADDITIVE
}

var loaded_scenes: Dictionary[int, Array]

const SCENE_MANIFEST = preload("res://scene_manifest.tres")

func _ready():
	var node = get_tree().current_scene
	
	get_tree().current_scene = self
	node.reparent.call_deferred(self)

func load_scene_async(scene_name: String, scene_load_mode: SceneLoadMode = SceneLoadMode.REPLACE) -> bool:
	var scene_index = SCENE_MANIFEST.scene_list.find_custom(func(x): return Util.get_file_name(x) == scene_name)
	if scene_index == -1: return false
	
	return await load_scene_by_index_async(scene_index, scene_load_mode)

func load_scene_by_index_async(scene_index: int, scene_load_mode: SceneLoadMode = SceneLoadMode.REPLACE):
	if scene_index <0 || scene_index >= SCENE_MANIFEST.scene_list.size(): return false
	
	if scene_load_mode == SceneLoadMode.REPLACE:
		for child in get_children():
			child.queue_free()
	
	var scene: PackedScene = load(SCENE_MANIFEST.scene_list[scene_index])
	
	var instance = scene.instantiate()
	
	add_child(instance)
	
	if !loaded_scenes.has(scene_index): loaded_scenes[scene_index] = []
	loaded_scenes[scene_index].append(instance)
	
	return true
