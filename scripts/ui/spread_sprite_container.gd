extends Node2D

class_name SpreadSpriteContainer

@export var max_distance : float
@export var container_width : int

func _ready():
	organize_children()

func _process(delta):
	organize_children()

func organize_children():
	var total_width = 0
	
	for c in get_children():
		total_width += c.texture.get_width()
	
	var margin = 0
	var margin_count = get_child_count() - 1
	
	if margin_count > 0:
		margin = (container_width - total_width) / margin_count
		
		if margin > max_distance:
			margin = max_distance
	
	total_width += margin * margin_count
	
	var pos = total_width / -2
		
	for c in get_children():
		var texture_width = c.texture.get_width()
		
		c.position = Vector2(pos + texture_width / 2, 0)
		
		pos += texture_width + margin
