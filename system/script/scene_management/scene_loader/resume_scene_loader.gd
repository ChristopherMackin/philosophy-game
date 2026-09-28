class_name ResumeSceneLoader
extends SceneLoader

func set_scene_state(slm: SceneLoadManager):
	Global.load_state_with_meta_tag.call_deferred()
	
