extends Node

class_name SceneChangeManager

@export var scene_change_data: SceneChangeData

func progress():
	SceneManager.replace_scene_async(scene_change_data.scene_name, scene_change_data.transition)
