@tool

extends Container

class_name StaggeredFlexContainer

func _notification(what):
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		queue_sort()
	if what == NOTIFICATION_SORT_CHILDREN:
		_sort_children()

func _sort_children():
	if get_child_count() <= 0:
		return
	
	var children = get_children()
	var max_x = children.map(func(x): return x.custom_minimum_size.x).max()
	var max_y = children.map(func(x): return x.custom_minimum_size.y).max()
	
	print("%s,%s" %[max_x, max_y])
