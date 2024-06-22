@tool
extends Container

class_name PoseScore

@export var pose : Pose:
	set(val):
		pose = val
		initialize()
@export var empty_texture : Texture2D
@export var filled_texture : Texture2D
@export var segment_count = 8:
	set(val):
		segment_count = val
		initialize()
@export var value = 0:
	set(val):
		value = val
		set_value(val)

@onready var icon = $Icon
var segments : Array[TextureRect]

func _ready():
	initialize()

func initialize():
	clear_segments()
	
	for i in segment_count:
		var tex = TextureRect.new()
		add_child(tex)
		segments.append(tex)
	
	var icon = pose.icon if pose else null
	var color = pose.color if pose else Color.BLACK
	
	set_icon(icon)
	set_color(color)
	set_value(value)

func set_icon(texture : Texture2D):
	if !icon:
		return
	
	icon.texture = texture

func clear_segments():
	for s in segments:
		s.queue_free()
	segments.clear()

func set_color(color : Color):
	if icon:
		icon.modulate = color
	
	for s in segments:
		s.modulate = color

func set_value(score : int):
	var i = 0
	for s in segments:
		s.texture = filled_texture if segment_count - i <= value else empty_texture
		i += 1
