extends Control

func _input(event):
	if Input.is_action_just_pressed("action_1"):
		SceneManager.load_scene.call_deferred("aaron_db01_debate")
