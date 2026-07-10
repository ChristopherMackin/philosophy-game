@tool
extends AnimationHandler

class_name CharacterTreeAnimationHandler

@export var animation_tree: CharacterAnimationTree

func _ready():
	if !animation_tree: return

func start_animation(name : String):
	if !animation_tree: return
	animation_tree.set_trigger(name)

func cancel_animation():
	if !animation_tree: return
	animation_tree.set_trigger("reset")
