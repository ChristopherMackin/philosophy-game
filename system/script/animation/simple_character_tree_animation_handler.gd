@tool
extends AnimationHandler

class_name SimpleCharacterTreeAnimationHandler

@export var animation_tree: CharacterAnimationTree

@export var animation: Animation:
	set(val):
		if !animation_tree || val == null: return
		for library_name in _animation_player.get_animation_library_list():
			var library:= _animation_player.get_animation_library(library_name)
			for anim_name in library.get_animation_list():
				if library.get_animation(anim_name) == val:
					start_animation("%s/%s" %[library_name, anim_name])

var _animation_player: AnimationPlayer:
	get(): 
		if !animation_tree: return null
		return animation_tree.get_node(animation_tree.anim_player)

func start_animation(name : String):
	if !animation_tree || !animation_tree.anim_player: return
	
	#print(animation_tree.get_node(animation_tree.anim_player).get_animation_list())
	
	if _animation_player.has_animation(name):
		var anim_node: AnimationNode = animation_tree.tree_root.get_node("Animation")
		if anim_node.animation != name:
			print(name)
			anim_node.animation = name

func cancel_animation():
	if !animation_tree || !animation_tree.anim_player: return
	
	if animation_tree.get_node(animation_tree.anim_player).has_animation("RESET"):
		animation_tree.tree_root.get_node("Animation").animation = "RESET"
