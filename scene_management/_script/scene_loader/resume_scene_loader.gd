class_name ResumeSceneLoader
extends SceneLoader

func set_scene_state(slm: SceneLoadManager):
	for node in slm.scene_state_nodes:
		node.load_state()
