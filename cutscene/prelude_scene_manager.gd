extends Node3D

@export var transition: PackedScene
@export var scene_name: String

func progress():
	SceneManager.replace_scene_async(scene_name, transition)
