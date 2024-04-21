@tool
extends TextureProgressBar

class_name MarkedProgressBar

@export var segment_divider_thickness : float = 5
@export var divider_color : Color = Color.BLACK
@export var vertical : bool = true

var cached_max = 0

func _draw():
	if vertical:
		for i in int(max_value) - 1:
			draw_line(Vector2(0, size.y - size.y * ((i + 1.0) / max_value)), 
				Vector2(size.x,  size.y - size.y * ((i + 1.0) / max_value)), 
				divider_color, 
				segment_divider_thickness)
	else:
		for i in int(max_value) - 1:
			draw_line(Vector2(size.x - size.x * ((i + 1.0) / max_value), 0), 
				Vector2(size.x - size.x * ((i + 1.0) / max_value), size.y), 
				divider_color, 
				segment_divider_thickness)

func _process(delta):
	if cached_max != max_value:
		cached_max = max_value
		queue_redraw()
