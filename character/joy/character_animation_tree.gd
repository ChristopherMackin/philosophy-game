extends AnimationTree

class_name CharacterAnimationTree

signal on_character_animation_finished(name: String)
signal on_character_animation_looped(name: String)

@export var is_talking: bool = false:
	get():
		return is_talking
	set(val):
		is_talking = val
		var blend_amount = 1 if is_talking else 0
		set("parameters/talking/blend_amount", blend_amount)

@export var is_blinking: bool = true:
	get():
		return is_blinking
	set(val):
		is_blinking = val
		var blend_amount = 1 if is_blinking else 0
		set("parameters/blinking/blend_amount", blend_amount)

var anim_node: AnimationNodeAnimation
var previous_normalized_position = -1
var previous_delta = -1

func _ready():
	anim_node = tree_root.get_node("Animation")

func _process(delta):
	var current_position = get("parameters/Animation/current_position")
	var current_length = get("parameters/Animation/current_length")
	var current_delta = get("parameters/Animation/current_delta")
	var current_normalized_position = clampf((float)(current_position / current_length), 0, 1)
	
	if previous_normalized_position > 0:
		if abs(previous_normalized_position - current_normalized_position) > .8:
			on_character_animation_looped.emit(anim_node.animation)
	
	if current_delta == 0 && previous_delta != current_delta:
		on_character_animation_finished.emit(anim_node.animation)
	
	previous_normalized_position = current_normalized_position
	previous_delta = current_delta

func play_animation(name: String):
	anim_node.animation = name
	previous_normalized_position = -1
	previous_delta = -1
