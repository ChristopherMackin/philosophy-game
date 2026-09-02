@tool
extends AnimationTree

class_name CharacterAnimationTree

@export var triggers: Dictionary[String, bool]

@export var talk_override: bool = false:
	get():
		return talk_override
	set(val):
		talk_override = val
		var state = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE if val else AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		if get("parameters/talk_override/request") != null:
			set("parameters/talk_override/request", state)

@export var blink_override: bool = false:
	get():
		return blink_override
	set(val):
		blink_override = val
		var state = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE if val else AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		if get("parameters/blink_override/request") != null:
			set("parameters/blink_override/request", state)

@export var blink_override_emotion: Const.Emotion

func set_trigger(_trigger: String):
	if triggers.has(_trigger):
		triggers[_trigger] = true

func get_trigger(_trigger: String):
	if triggers.has(_trigger):
		if triggers[_trigger] == true:
			triggers[_trigger] = false
			return true
		else:
			return false
