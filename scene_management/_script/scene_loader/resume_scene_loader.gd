class_name ResumeSceneLoader
extends SceneLoader

func set_scene_state(slm: SceneLoadManager):
	super.set_scene_state(slm)
	
	for node in slm.scene_state_nodes:
		node.load_state()
