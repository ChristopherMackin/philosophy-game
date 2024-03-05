extends Sprite2D

class_name MeterUI

@export var debate_settings : DebateSettings :
	get:
		return debate_settings
	set(value):
		debate_settings = value
		queue_redraw()

@export var radius : float = 150 :
	get:
		return radius
	set(value):
		radius = value
		queue_redraw()
@export var thickness : int = 5 :
	get:
		return thickness
	set(value):
		thickness = value
		queue_redraw()
@export var border_color : Color = Color.WHITE:
	get:
		return border_color
	set(value):
		border_color = value
		queue_redraw()
@export_range(0, 1, .01) var saturation_modifier : float = .5 :
	get:
		return saturation_modifier
	set(value):
		saturation_modifier = value
		queue_redraw()
@export_range(0, 1, .01) var brightness_modifier : float = .5 :
	get:
		return brightness_modifier
	set(value):
		brightness_modifier = value
		queue_redraw()

var current_score : Vector2 = Vector2.ZERO
var draw_score : Vector2 = Vector2.ZERO

signal animation_finished

var start_vector : Vector2
var end_vector : Vector2
var timer : float = 0
@export var duration : float

func _process(delta):
	if timer <= 0:
		return
	
	timer -= delta
	
	if timer <= 0:
		draw_score = end_vector
		animation_finished.emit()
	else:
		draw_score = start_vector.lerp(end_vector, 1- timer/duration)
	
	queue_redraw()
	

func _draw():
	if debate_settings == null:
		return
	
	draw_background()
	draw_segments(draw_score)
	draw_lines()

func draw_background():
	var segments = [
		debate_settings.pos_y_suit,
		debate_settings.pos_x_suit,
		debate_settings.neg_y_suit,
		debate_settings.neg_x_suit,
	]
	
	var starting_angle := -45
	
	for segment in segments:
		var desaturated_color : Color = segment.color
		desaturated_color.s = desaturated_color.s * saturation_modifier
		desaturated_color.v = desaturated_color.v * brightness_modifier
		
		draw_circle_arc_poly(Vector2.ZERO, radius, starting_angle, starting_angle + 90, desaturated_color)
		starting_angle += 90

func draw_segments(score : Vector2):
	#For Y
	if score.y > 0:
		draw_circle_arc_poly(Vector2.ZERO, 
		radius * score.y / debate_settings.win_amount, 
		-45, 45, debate_settings.pos_y_suit.color)
	
	elif score.y < 0:
		draw_circle_arc_poly(Vector2.ZERO, 
		radius * abs(score.y) / debate_settings.win_amount, 
		135, 225, debate_settings.neg_y_suit.color)
	
	#For X
	if score.x > 0:
		draw_circle_arc_poly(Vector2.ZERO, 
		radius * score.x / debate_settings.win_amount, 
		45, 135, debate_settings.pos_x_suit.color)
	
	elif score.x < 0:
		draw_circle_arc_poly(Vector2.ZERO, 
		radius * abs(score.x) / debate_settings.win_amount, 
		225, 315, debate_settings.neg_x_suit.color)

func draw_lines():
	var leg_length := sqrt(radius * radius / 2)
	
	#Draw Diagonals
	draw_line(-Vector2.ONE * leg_length, Vector2.ONE * leg_length, border_color, thickness)
	draw_line(Vector2(-1, 1) * leg_length, Vector2(1, -1) * leg_length, border_color, thickness)
	
	var line_count : float = debate_settings.win_amount

	for n in line_count:
		draw_arc(Vector2.ZERO, radius * (n+1) / debate_settings.win_amount , 0, 360, 50, border_color, thickness)

# From Bergerboi's Pastebin: https://pastebin.com/UjYyXGXs
# directly from: http://docs.godotengine.org/en/latest/tutorials/2d/custom_drawing_in_2d.html
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])
 
	for i in range(nb_points+1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func update_score(score : Vector2):
	start_vector = current_score
	end_vector = score
	
	timer = duration
	
	current_score = score
