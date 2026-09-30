extends Node
class_name SceneChangeNode

@export var scene_change_data: SceneChangeData

func transition_scene():
	if scene_change_data.save_state:
		for node in Global.state_nodes:
			node.save_state()
	Global.blackboard.add_flag(Flag.SPAWN_INDEX, scene_change_data.next_scene_spawn_index)
	SceneManager.replace_scene_async(scene_change_data.scene_name, scene_change_data.transition)
