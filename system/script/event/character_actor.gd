extends Actor

class_name CharacterActor

@export var _layer_mask: LayerMask
@export var _dialgoue_camera: PhantomCamera3D
@export var _look_at_modifier: LookAtModifier3D

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

func focus_actor(val: bool):
	if val:
		_layer_mask.set_layer(20, true)
		_dialgoue_camera.priority = 1
	else:
		_layer_mask.set_layer(20, false)
		_dialgoue_camera.priority = 0

func focus_look_at_body(body: Node3D):
	_look_at_modifier.target_node = body.get_path()

func unfocus_look_at_body(body: Node3D):
	if _look_at_modifier.target_node == body.get_path():
		_look_at_modifier.target_node = NodePath()
