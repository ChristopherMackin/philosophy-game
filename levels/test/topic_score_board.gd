extends Control

class_name TopicScoreBoard

@export var suit_divider_thickness : float = 10
@export var segment_divider_thickness : float = 5
@export var divider_color : Color = Color.BLACK

@export var segment_count : int = 5

# Called when the node enters the scene tree for the first time.
func _draw():
	var style_box = StyleBoxFlat.new()
	style_box.set_corner_radius_all(20)
	draw_style_box(style_box, Rect2(Vector2.ZERO, Vector2(size.x, size.y)))
	
	draw_line(Vector2(0, size.y/2), Vector2(size.x, size.y/2), divider_color, suit_divider_thickness)
	
	#draw positive lines
	for i in segment_count - 1:
		draw_line(Vector2(0, size.y/2 - (size.y/2) * ((i + 1.0) / segment_count)), 
			Vector2(size.x,  size.y/2 - (size.y/2) * ((i + 1.0) / segment_count)), 
			divider_color, 
			segment_divider_thickness)
	
	#draw negitive lines
	for i in segment_count - 1:
		draw_line(Vector2(0, size.y/2 + (size.y/2) * ((i + 1.0) / segment_count)), 
			Vector2(size.x,  size.y/2 + (size.y/2) * ((i + 1.0) / segment_count)), 
			divider_color, 
			segment_divider_thickness)

func _process(delta):
	queue_redraw()
