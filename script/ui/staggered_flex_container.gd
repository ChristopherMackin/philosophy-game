@tool

extends Container

class_name StaggeredFlexContainer

@export var horizontal_spacing : int:
	set(val):
		horizontal_spacing = val if val >= 0 else 0
		queue_sort()
@export var perferred_vertical_spacing : int:
	set(val):
		perferred_vertical_spacing = val if val >= 0 else 0
		queue_sort()

func _notification(what):
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		queue_sort()
	if what == NOTIFICATION_SORT_CHILDREN:
		_sort_children()

func _sort_children():
	if get_child_count() <= 0:
		return
	
	var children = get_children()
	var max_x : int = 0
	var max_y : int = 0
	
	#Get max minimum_custom_size
	for child in children:
		var custom_min = child.custom_minimum_size
		custom_min.x *= child.scale.x
		custom_min.y *= child.scale.y
		
		max_x = custom_min.x \
		if custom_min.x > max_x \
		else max_x
		
		max_y = custom_min.y \
		if custom_min.y > max_y \
		else max_y
	
	#projected elements per row

	var elements_per_row : int = floor(size.x / (max_x + horizontal_spacing))
	
	var index = 0
	for child in children:
		var col : int = index % elements_per_row
		var row : int = floor(index / elements_per_row)
		var is_odd := bool(row % 2)
		
		if is_odd:
			child.position = Vector2(\
			size.x - (max_x + horizontal_spacing + ((max_x + horizontal_spacing) * (col))),\
			max_y * floor(row))
		else:
			child.position = Vector2(\
			horizontal_spacing + ((max_x + horizontal_spacing) * (col)),\
			max_y * floor(row))
		
		index += 1
