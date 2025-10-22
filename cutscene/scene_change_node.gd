extends Node

class_name SceneChangeNode

@export var scene_name: String
@export var transition: PackedScene

func progress():
	SceneManager.replace_scene_async(scene_name, transition)
