class_name AnimationSceneLoader
extends SceneLoader

@export var state_animation_name: String

func set_scene_state(slm: SceneLoadManager):
	if Global.blackboard.has_flag(Flag.SPAWN_INDEX):
		var spawn_index = Global.blackboard.get_flag_value(Flag.SPAWN_INDEX)
		if spawn_index < slm.spawn_locations.size():
			var spawn = slm.spawn_locations[spawn_index]
			slm.character_controller.global_position = spawn.global_position
			slm.character_controller.global_rotation = spawn.global_rotation
	
	if !slm.scene_animator || !slm.scene_animator.has_animation(state_animation_name): return
	slm.scene_animator.play(state_animation_name)
