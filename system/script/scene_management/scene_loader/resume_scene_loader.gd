class_name ResumeSceneLoader
extends SceneLoader

func set_scene_state(slm: SceneLoadManager):
	for node in slm.room_state_nodes:
		node.load_state()
