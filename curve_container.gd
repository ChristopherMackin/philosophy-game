@tool
extends Container
class_name CurveContainer

@export var hand_curve: Curve:
	set(value):
		# Disconnect previous curve to avoid multiple connections
		if hand_curve != null:
			if hand_curve.is_connected("changed", queue_sort):
				hand_curve.disconnect("changed", queue_sort)
		hand_curve = value
		if hand_curve != null:
			hand_curve.connect("changed", queue_sort)

@export var rotation_curve: Curve:
	set(value):
		# Disconnect previous curve to avoid multiple connections
		if rotation_curve != null:
			if rotation_curve.is_connected("changed", queue_sort):
				rotation_curve.disconnect("changed", queue_sort)
		rotation_curve = value
		if rotation_curve != null:
			rotation_curve.connect("changed", queue_sort)

@export var max_rotation_degrees := 10:
	set(val):
		max_rotation_degrees = val
		queue_sort()
@export var x_sep := 20:
	set(val):
		x_sep = val
		queue_sort()
@export var y_min := 50:
	set(val):
		y_min = val
		queue_sort()
@export var y_max := -50:
	set(val):
		y_max = val
		queue_sort()

@export var card_size: Vector2
var _card_pivot: Vector2:
	get():
		return Vector2(card_size.x/2, card_size.y)

func _notification(what):
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		queue_sort()
	if what == NOTIFICATION_SORT_CHILDREN:
		_sort_children()

func _sort_children() -> void:
	var cards := get_child_count()
	if cards <= 0: return
	elif cards == 1:
		var card := get_child(0)
		var y_multiplier := hand_curve.sample(.5)
		var rot_multiplier := rotation_curve.sample(.5)
		
		var final_x: float = size.x/2 -card_size.x / 2
		var final_y: float = y_min + y_max * y_multiplier
		
		card.pivot_offset = _card_pivot
		card.position = Vector2(final_x, final_y)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier
		
		return
	
	var all_cards_size := card_size.x * cards + x_sep * (cards - 1)
	var final_x_sep = x_sep
	
	if all_cards_size > size.x:
		final_x_sep = (size.x - card_size.x * cards) / (cards - 1)
		all_cards_size = size.x

	var offset := (size.x - all_cards_size) / 2
	
	for i in cards:
		var card := get_child(i)
		var y_multiplier := hand_curve.sample(1.0 / (cards-1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards-1) * i)
		
		var final_x: float = offset + card_size.x * i + final_x_sep * i
		var final_y: float = y_min + y_max * y_multiplier
		
		card.pivot_offset = _card_pivot
		card.position = Vector2(final_x, final_y)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier
