extends Node3D

@export var transition: PackedScene

func progress():
	SceneManager.replace_scene_async("aaron_db01_debate", transition)
