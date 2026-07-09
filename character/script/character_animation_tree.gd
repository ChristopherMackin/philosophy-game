@tool
extends AnimationTree

class_name CharacterAnimationTree

@export var triggers: Dictionary[String, bool]

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
		var blink_int = 1 if val else 0
		set("parameters/blink_trigger/add_amount", blink_int)

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
