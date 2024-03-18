extends Node2D

class_name Lerp2D

var _parent

var starting_pos : Vector2
var target_pos : Vector2

var timer : float
@export var duration : float = 2

func _enter_tree():
	_parent = get_parent()

func _process(delta):
	if timer <= 0:
		return
	
	timer -= delta
	
	var pos = starting_pos.lerp(target_pos, 1 - (timer / duration)) if timer > 0 else target_pos
	
	_parent.position = pos

func lerp_to_position(target : Vector2):
	timer = duration
	starting_pos = _parent.position
	target_pos = target
