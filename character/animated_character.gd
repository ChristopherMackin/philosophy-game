extends Node3D

class_name AnimatedCharacter

@export var layer_mask: LayerMask

@export var dialogue_display_name: String
@export var dialgoue_camera: PhantomCamera3D
@export var dialogue_area_override: DialogueArea

@export var character_animation_tree: CharacterAnimationTree

@export var is_talking: bool = false:
	get():
		return character_animation_tree.is_talking
	set(val):
		character_animation_tree.is_talking = val

@export var is_blinking: bool = true:
	get():
		return character_animation_tree.is_blinking
	set(val):
		character_animation_tree.is_blinking = val
