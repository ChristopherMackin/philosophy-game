@tool
extends AnimationTree

class_name CharacterAnimationTree

@export var is_talking: bool = false:
	get():
		return is_talking
	set(val):
		is_talking = val
		var state = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE if val else AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		set("parameters/talk_trigger/request", state)

@export var is_blinking: bool = true:
	get():
		return is_blinking
	set(val):
		is_blinking = val
		var state = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE if val else AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		set("parameters/blink_trigger/request", state)

func set_trigger(_trigger: String):
	pass
