@tool 
extends Control

@export var width_bottom: float = 60.0:  # Width at the start of the curve
	set(val):
		width_bottom = val
		_regenerate_line()
@export var width_top: float = 20.0:     # Width at the end of the curve
	set(val):
		width_top = val
		_regenerate_line()
@export var background: Polygon2D:
	set(val):
		background = val
		_regenerate_line()
@export var outline: Line2D:
	set(val):
		outline = val
		_regenerate_line()
@export var points: Node:
	set(val):
		if points:
			for child in points.get_children():
				Util.optional_disconnect(child, "item_rect_changed", _regenerate_line)
			Util.optional_disconnect(points, "child_entered_tree", _set_up_redraw)
			Util.optional_disconnect(points, "item_rect_changed", _regenerate_line)
			Util.optional_disconnect(points, "child_exiting_tree", _regenerate_line.unbind(1))
		
		points = val
		
		if points:
			for child in points.get_children():
				_set_up_redraw(child)
			Util.optional_connect(points, "child_entered_tree", _set_up_redraw)
			Util.optional_connect(points, "item_rect_changed", _regenerate_line)
			Util.optional_connect(points, "child_exiting_tree", _regenerate_line.unbind(1))

@export var thickness: float = 20.0:
	set(val):
		thickness = val
		_regenerate_line()

@export var smoothing: float = 0.3

func _regenerate_line() -> void:
	if !background || !outline || !points: return
	
	var curve:= Curve2D.new()
		
	for i in points.get_child_count():
		var current = points.get_child(i).global_position
		curve.add_point(current)
		
		# Skip handles for start and end points
		if i == 0 or i == points.get_child_count() - 1:
			continue
			
		# Calculate auto-handles based on neighboring points
		var prev = points.get_child(i - 1).global_position
		var next = points.get_child(i + 1).global_position
		
		# Calculate the tangent vector between the previous and next point
		var tangent = (next - prev).normalized()
		
		# Set the handles relative to the current point position
		var in_handle = -tangent * (current - prev).length() * smoothing
		var out_handle = tangent * (next - current).length() * smoothing
		
		curve.set_point_in(i, in_handle)
		curve.set_point_out(i, out_handle)
	
	generate_tapered_shape(curve)

func _set_up_redraw(node: Node):
	Util.optional_connect(node, "item_rect_changed", _regenerate_line)

func generate_tapered_shape(curve: Curve2D) -> void:
	# 1. Get the highly detailed points along the spine
	var spine_points: PackedVector2Array = curve.get_baked_points()
	var point_count: int = spine_points.size()
	
	if point_count < 2:
		push_warning("Curve2D needs at least 2 points.")
		return

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
	
	for p in left_side:
		closed_loop.append(p)
		
	right_side.reverse()
	for p in right_side:
		closed_loop.append(p)
		
	# 4. Apply to your visual nodes
	outline.points = closed_loop       # Draws the perfect outline
	# Close the final gap explicitly back to the starting point
	closed_loop.append(left_side[0])
	background.polygon = closed_loop  # Fills the inner shape
