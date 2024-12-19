@tool

extends Container

class_name StaggeredFlexContainer

func _notification(what):
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		queue_sort()
	if what == NOTIFICATION_SORT_CHILDREN:
		# Must re-sort the children
		for c in get_children():
			# Fit to own size
			fit_child_in_rect(c, Rect2(Vector2(), size))
