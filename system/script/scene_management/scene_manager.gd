extends Node

signal on_scene_unloaded
signal on_scene_loaded

var loaded_scenes: Dictionary[int, Array]
var canvas: CanvasLayer

@export_global_file("*.tscn") var _scene_list: Array[String]
var scene_list: Array[String]:
	get: return _scene_list
	
func _ready():
	var node = get_tree().current_scene
	var scene_index = _scene_list.find_custom(func(x): return Util.get_file_name(x) == node.name)
	loaded_scenes[scene_index] = [node]
	
	canvas = CanvasLayer.new()
	canvas.layer = 10
	
	get_tree().current_scene = self
	add_child(canvas)
	
	if node is Control:
		node.reparent.call_deferred(canvas)
	else:
		node.reparent.call_deferred(self)

func replace_scene_async(scene_name: String, transition: PackedScene = null) -> bool:
	var scene_index = _scene_list.find_custom(func(x): return Util.get_file_name(x) == scene_name)
	if scene_index == -1: return false
	
	return await replace_scene_by_index_async(scene_index, transition)

func replace_scene_by_index_async(scene_index: int, transition: PackedScene = null):
	if scene_index <0 || scene_index >= _scene_list.size(): return false
	
	var free_functions: Array[Callable] = []
	for key in loaded_scenes:
		for node: Node in loaded_scenes[key]:
			free_functions.append(func():
				node.queue_free()
				await node.tree_exited
			)
	
	if transition != null:
		var transition_instance = transition.instantiate()
		if transition_instance is SceneTransition:
			canvas.add_child(transition_instance)
			await transition_instance.start_transition_out()
			
			await Util.await_all(free_functions)
			loaded_scenes.clear()
			on_scene_unloaded.emit()
			
			instantiate_scene_by_index.call_deferred(scene_index)
			
			await transition_instance.start_transition_in()
			transition_instance.queue_free()
			on_scene_loaded.emit()
		
		else:
			transition_instance.queue_free()
			
			await Util.await_all(free_functions)
			loaded_scenes.clear()
			on_scene_unloaded.emit()
		
			instantiate_scene_by_index.call_deferred(scene_index)
			on_scene_loaded.emit()
	
	else:
		await Util.await_all(free_functions)
		loaded_scenes.clear()
		on_scene_unloaded.emit()
		
		instantiate_scene_by_index.call_deferred(scene_index)
		on_scene_loaded.emit()
	
	return true

func instantiate_scene_by_index(scene_index: int):
	var scene: PackedScene = load(_scene_list[scene_index])
	
	var instance = scene.instantiate()
	
	if instance is Control:
		canvas.add_child(instance)
	else:
		add_child(instance)
	
	if !loaded_scenes.has(scene_index): loaded_scenes[scene_index] = []
	loaded_scenes[scene_index].append(instance)
