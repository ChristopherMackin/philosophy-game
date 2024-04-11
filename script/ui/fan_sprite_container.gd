@tool
extends Node2D

class_name FanSpriteContainer

@export var container_width : float = 1000
var actual_width : float = 0

@export var preferred_margin = 0

signal on_orgainze

var _organize : bool = false

var are_children_enabled : bool = false:
	get:
		return are_children_enabled
	set(val):
		for child in get_children():
			child.process_mode = Node.PROCESS_MODE_DISABLED if val else Node.PROCESS_MODE_INHERIT
		are_children_enabled = val

func _process(delta):
	if _organize: 
		organize_children()
		_organize = false

func _notification(what):
	if what == 24:
		are_children_enabled = are_children_enabled
		queue_organize()

func queue_organize():
	_organize = true

func organize_children():
	var n = get_child_count()
	var children = get_children()
	var max = get_max_with_rotation(children)
	var width = max + (n - 1) * preferred_margin
	
	var margin : float
	var pos : Vector2
	
	if n <= 1:
		margin = 0
		pos = Vector2.ZERO
		actual_width = max
	elif width <= container_width:
		margin = preferred_margin
		pos = Vector2(-(margin * (n - 1) /2), 0)
		actual_width = width
	else:
		var available_space = (container_width - max)
		
		if available_space < 0:
			margin = 0
			pos = Vector2.ZERO
		else:
			margin = available_space / (n - 1)
			pos = Vector2(-available_space /2, 0)
		
		actual_width = container_width
	
	for child : Sprite2D in children:
		child.position = pos
		pos += Vector2(margin, 0)
	
	on_orgainze.emit()
	
func get_max_with_rotation(sprite_array : Array) -> float:
	var max : float = 0
	for sprite : Sprite2D in sprite_array:
		var width = abs(sprite.get_rect().size.x * cos(deg_to_rad(sprite.rotation_degrees)) + abs(sprite.get_rect().size.y * sin(deg_to_rad(sprite.rotation_degrees))))
		max = width if width > max else max
	return max
