extends Control

func _input(event):
	if Input.is_action_just_pressed("action_1"):
		print("TEST")
		SceneManager.load_scene.call_deferred("res://level/debate/aaron_db01_debate.tscn")
