@tool
extends Actor

class_name CharacterActor

signal on_set_talking(val: bool)

@export var _layer_mask: LayerMask
@export var _dialgoue_camera: PhantomCamera3D
@export var _look_at_modifier: LookAtModifier3D

@export var character_animation_tree: CharacterAnimationTree

@export var talk_override: bool = false:
	get():
		if character_animation_tree:
			return character_animation_tree.talk_override
		return false
	set(val):
		if character_animation_tree: character_animation_tree.talk_override = val

@export var blink_override: bool = false:
	get():
		if character_animation_tree:
			return character_animation_tree.blink_override
		return false
	set(val):
		if character_animation_tree: character_animation_tree.blink_override = val

func focus_actor(val: bool):
	if val:
		_layer_mask.set_layer(20, true)
		_dialgoue_camera.priority = 1
	else:
		_layer_mask.set_layer(20, false)
		_dialgoue_camera.priority = 0

func focus_look_at_body_shape(_area_rid, body: Node3D, body_shape_index, _local_shape_index):
	var body_shape_owner = body.shape_find_owner(body_shape_index)
	var body_shape_node = body.shape_owner_get_owner(body_shape_owner)
	
	if !_look_at_modifier: return
	_look_at_modifier.target_node = body_shape_node.get_path()

func unfocus_look_at_body_shape(_area_rid, body: Node3D, body_shape_index, _local_shape_index):
	var body_shape_owner = body.shape_find_owner(body_shape_index)
	var body_shape_node = body.shape_owner_get_owner(body_shape_owner)
	
	if !_look_at_modifier: return
	if _look_at_modifier.target_node == body_shape_node.get_path():
		_look_at_modifier.target_node = NodePath()

func focus_look_at_area_shape(_area_rid, area: Area3D, area_shape_index, _local_shape_index):
	var area_shape_owner = area.shape_find_owner(area_shape_index)
	var area_shape_node = area.shape_owner_get_owner(area_shape_owner)
	
	if !_look_at_modifier: return
	_look_at_modifier.target_node = area_shape_node.get_path()

func unfocus_look_at_area_shape(_area_rid, area: Area3D, area_shape_index, _local_shape_index):
	var area_shape_owner = area.shape_find_owner(area_shape_index)
	var area_shape_node = area.shape_owner_get_owner(area_shape_owner)
	
	if !_look_at_modifier: return
	if _look_at_modifier.target_node == area_shape_node.get_path():
		_look_at_modifier.target_node = NodePath()
