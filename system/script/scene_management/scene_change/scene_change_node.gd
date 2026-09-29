extends Node
class_name SceneChangeNode

@export var scene_change_data: SceneChangeData

func transition_scene():
	Global.blackboard.add_flag(Flag.SPAWN_INDEX, scene_change_data.spawn_index)
	SceneManager.replace_scene_async(scene_change_data.scene_name, scene_change_data.transition)
