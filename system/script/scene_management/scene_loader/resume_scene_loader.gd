class_name ResumeSceneLoader
extends SceneLoader

func set_scene_state(slm: SceneLoadManager):
	Global.load_collision_state.call_deferred()
	
