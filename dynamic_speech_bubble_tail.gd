@tool 
extends Control

@export_category("Body")
@export var width: float = 300.0:
	set(value):
		width = value
		_draw_bubble()
@export var height: float = 150.0:
	set(value):
		height = value
		_draw_bubble()
@export var corner_radius: float = 20.0:
	set(value):
		corner_radius = value
		_draw_bubble()
@export var resolution: int = 8: # Number of points per corner arc
	set(value):
		resolution = value
		_draw_bubble()

@export_category("Tail")
@export var width_bottom: float = 60.0:  # Width at the start of the curve
	set(val):
		width_bottom = val
		_draw_bubble()
@export var width_top: float = 20.0:     # Width at the end of the curve
	set(val):
		width_top = val
		_draw_bubble()
@export var smoothing: float = 0.3:
	set(val):
		smoothing = val
		_draw_bubble()

@export_category("Dependencies")
@export var background: Polygon2D:
	set(val):
		background = val
		_draw_bubble()
@export var outline: Line2D:
	set(val):
		outline = val
		_draw_bubble()
@export var point_parent: Node:
	set(val):
		if point_parent:
			for child in point_parent.get_children():
				Util.optional_disconnect(child, "item_rect_changed", _draw_bubble)
			Util.optional_disconnect(point_parent, "child_entered_tree", _set_up_redraw)
			Util.optional_disconnect(point_parent, "item_rect_changed", _draw_bubble)
			Util.optional_disconnect(point_parent, "child_exiting_tree", _draw_bubble.unbind(1))
		
		point_parent = val
		
		if point_parent:
			for child in point_parent.get_children():
				_set_up_redraw(child)
			Util.optional_connect(point_parent, "child_entered_tree", _set_up_redraw)
			Util.optional_connect(point_parent, "item_rect_changed", _draw_bubble)
			Util.optional_connect(point_parent, "child_exiting_tree", _draw_bubble.unbind(1))

@export_category("Border")
@export var thickness: float = 20.0:
	set(val):
		thickness = val
		_draw_bubble()

func _draw_bubble():
	_draw_tail()

func _draw_tail() -> void:
	if !background || !outline || !point_parent: return
	
	var points: Array[Vector2]
	points.assign(point_parent.get_children().map(func(x): return x.global_position))
	var curve = generate_curve(points)
	
	var tail_shape = generate_tapered_shape(curve)
	var body_shape = _generate_body_shape()
	
	var union = Geometry2D.merge_polygons(body_shape, tail_shape)
	print(union)
	
	background.polygon = union[0] # Fills the inner shape
	outline.points = union[0]

func _set_up_redraw(node: Node):
	Util.optional_connect(node, "item_rect_changed", _draw_bubble)

func generate_curve(points: Array[Vector2]) -> Curve2D:
	var curve:= Curve2D.new()
		
	for i in points.size():
		var current = points[i]
		curve.add_point(current)
		
		# Skip handles for start and end points
		if i == 0 or i == points.size() - 1:
			continue
			
		# Calculate auto-handles based on neighboring points
		var prev = points[i - 1]
		var next = points[i + 1]
		
		# Calculate the tangent vector between the previous and next point
		var tangent = (next - prev).normalized()
		
		# Set the handles relative to the current point position
		var in_handle = -tangent * (current - prev).length() * smoothing
		var out_handle = tangent * (next - current).length() * smoothing
		
		curve.set_point_in(i, in_handle)
		curve.set_point_out(i, out_handle)
		
	return curve

func generate_tapered_shape(curve: Curve2D) -> PackedVector2Array:
	# 1. Get the highly detailed points along the spine
	var spine_points: PackedVector2Array = curve.get_baked_points()
	var point_count: int = spine_points.size()
	
	if point_count < 2:
		push_warning("Curve2D needs at least 2 points.")
		return PackedVector2Array([])

	var left_side: PackedVector2Array = []
	var right_side: PackedVector2Array = []

	# 2. Calculate offset points for each step along the spine
	for i in range(point_count):
		var current_point: Vector2 = spine_points[i]
		
		# Determine the forward heading direction (tangent)
		var forward: Vector2
		if i < point_count - 1:
			forward = (spine_points[i+1] - current_point).normalized()
		else:
			forward = (current_point - spine_points[i-1]).normalized()
		
		# Perpendicular vector pointing to the right side of the curve
		var normal: Vector2 = Vector2(-forward.y, forward.x)
		
		# Linearly interpolate the width from bottom (start) to top (end)
		var t: float = float(i) / float(point_count - 1)
		var current_half_width: float = lerp(width_bottom, width_top, t) / 2.0
		
		# Store the left and right boundaries
		left_side.append(current_point - (normal * current_half_width))
		right_side.append(current_point + (normal * current_half_width))

	# 3. Construct a single closed loop of vertices
	# We go up the left side, then loop back down the right side in reverse
	var closed_loop: PackedVector2Array = []
	
	for p in right_side:
		closed_loop.append(p)
		
	left_side.reverse()
	for p in left_side:
		closed_loop.append(p)
		
	closed_loop.append(right_side[0])
		
	return closed_loop

func _generate_body_shape() -> PackedVector2Array:
	var pts = PackedVector2Array()
	var r = min(corner_radius, min(width, height) / 2.0)
	
	# Top-Left Corner
	_add_arc(pts, Vector2(r - width/2, r - height/2), r, 180, 270, resolution)
	# Top-Right Corner
	_add_arc(pts, Vector2(width/2 - r, r - height/2), r, 270, 360, resolution)
	# Bottom-Right Corner
	_add_arc(pts, Vector2(width/2 - r, height/2 - r), r, 0, 90, resolution)
	# Bottom-Left Corner
	_add_arc(pts, Vector2(r - width/2, height/2 - r), r, 90, 180, resolution)
	
	return pts

func _add_arc(arr: PackedVector2Array, center: Vector2, radius: float, start_deg: float, end_deg: float, steps: int) -> void:
	for i in range(steps + 1):
		var ang = deg_to_rad(start_deg + (i / float(steps)) * (end_deg - start_deg))
		arr.append(center + Vector2(cos(ang), sin(ang)) * radius)
