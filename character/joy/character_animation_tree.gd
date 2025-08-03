@tool
extends AnimationTree

class_name CharacterAnimationTree

signal on_character_animation_finished(name: String)
signal on_character_animation_looped(name: String)

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

@export_group("idle_variation")
@export var idle_variation_count: int = 0
@export var idle_variation_min: float = 1.5
@export var idle_variation_max: float = 4.2

var action_node: AnimationNodeAnimation
var idle_variant_node: AnimationNodeAnimation
var previous_normalized_position = -1
var previous_delta = -1

func _ready():
	action_node = tree_root.get_node("action")
	idle_variant_node = tree_root.get_node("idle_variant")
	
	await GlobalTimer.wait_for_seconds(randf_range(idle_variation_min, idle_variation_max))
	play_idle_variant()

func _process(delta):
	var current_position = get("parameters/action/current_position")
	var current_length = get("parameters/action/current_length")
	var current_delta = get("parameters/action/current_delta")
	
	if current_length <= 0: return
	
	var current_normalized_position = clampf((float)(current_position / current_length), 0, 1)
	
	if previous_normalized_position > 0:
		if abs(previous_normalized_position - current_normalized_position) > .8:
			on_character_animation_looped.emit(action_node.animation)
	
	if current_delta == 0 && previous_delta != current_delta:
		on_character_animation_finished.emit(action_node.animation)
	
	previous_normalized_position = current_normalized_position
	previous_delta = current_delta

func play_animation(name: String):
	action_node.animation = name
	previous_normalized_position = -1
	previous_delta = -1
	set("parameters/take_action/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func play_idle_variant():
	if idle_variation_count <= 0: return
	
	var variant_index = randi_range(1, idle_variation_count)
	idle_variant_node.animation = "idle_variant_0" + str(variant_index)
	set("parameters/idling/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await GlobalTimer.wait_for_seconds(randf_range(idle_variation_min, idle_variation_max))
	play_idle_variant()
