@tool
extends Node2D

class_name FanSpriteContainer

@export var container_width : float = 1000
var actual_width : float = 0

@export var preferred_margin = 0

func _ready():
	organize_children()

func _process(delta):
	organize_children()

func organize_children():

	var n = get_child_count()
	var children = get_children()
	
	actual_width = 0
	
	if n <= 1:
		for child in children:
			child.position = Vector2(0,0)
			actual_width = child.get_rect().size.x
		return
	
	var max : float = 0
	for child : Sprite2D in children:
		var width = abs(child.get_rect().size.x * cos(deg_to_rad(child.rotation_degrees)) + abs(child.get_rect().size.y * sin(deg_to_rad(child.rotation_degrees))))
		max = width if width > max else max
	
	var width = max + (n - 1) * preferred_margin
	var margin
	var starting_pos
	
	if width <= container_width:
		margin = preferred_margin
		starting_pos = Vector2(-(margin * (n - 1) /2), 0)
		actual_width = width
	else:
		var available_space = (container_width - max)
		
		if available_space < 0:
			margin = 0
			starting_pos = Vector2.ZERO
			actual_width = container_width
		else:
			margin = available_space / (n - 1)
			starting_pos = Vector2(-available_space /2, 0)
			actual_width = max
	
	for child : Sprite2D in children:
		child.position = starting_pos
		
		starting_pos += Vector2(margin, 0)
	
