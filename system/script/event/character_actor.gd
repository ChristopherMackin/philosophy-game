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

func focus_look_at_shape(area_rid, area: Area3D, area_shape_index, local_shape_index):
	var shape_owner = area.shape_find_owner(area_shape_index)
	var shape_node = area.shape_owner_get_owner(shape_owner)

	_look_at_modifier.target_node = shape_node.get_path()


func unfocus_look_at_shape(area_rid, area, area_shape_index, local_shape_index):
	var shape_owner = area.shape_find_owner(area_shape_index)
	var shape_node = area.shape_owner_get_owner(shape_owner)
	
	if _look_at_modifier.target_node == shape_node.get_path():
		_look_at_modifier.target_node = NodePath()
