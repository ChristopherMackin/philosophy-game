class_name AnimationSceneLoader
extends SceneLoader

@export var state_animation_name: String

func set_scene_state(slm: SceneLoadManager):
	if !slm.scene_animator: return
	slm.scene_animator.play(state_animation_name)
