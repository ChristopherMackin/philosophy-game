extends Node3D

@export var transition: PackedScene

func progress():
	SceneManager.replace_scene_async("lvl_aaron_db01", transition)
