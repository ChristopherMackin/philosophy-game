extends AnimationHandler

class_name CharacterTreeAnimationHandler

@export var animation_tree: CharacterAnimationTree

func _ready():
	if !animation_tree: return
	animation_tree.on_character_animation_finished.connect(func(anim_name): on_animation_finished.emit(anim_name))
	animation_tree.on_character_animation_looped.connect(func(anim_name): on_animation_finished.emit(anim_name))

func start_animation(name : String):
	if !animation_tree: return
	animation_tree.play_animation(name)

func cancel_animation():
	if !animation_tree: return
	animation_tree.tree_root.get_node("Animation").animation = "RESET"
