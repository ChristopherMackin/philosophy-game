class_name AnimationSceneLoader
extends SceneLoader

@export var state_animation_name: String

func set_scene_state(slm: SceneLoadManager):
	super.set_scene_state(slm)
	
	if !slm.scene_animator || !slm.scene_animator.has_animation(state_animation_name): return
	slm.scene_animator.play(state_animation_name)
