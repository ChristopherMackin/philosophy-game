@tool
extends HBoxContainer

class_name PoseArea

@export var pose : Pose:
	set(val):
		pose = val
		initialize.call_deferred()

var icon : TextureRect

@export var slot_count : int:
	set(val):
		if val < 0:
			return
		slot_count = val
		initialize.call_deferred()
@export var slot_texture : Texture2D
var slots : Array[TextureRect]

@export var height : int:
	set(val):
		height = val
		initialize.call_deferred()

func _ready():
	initialize.call_deferred()

func initialize():
	for child in get_children():
		child.free()
	
	slots.clear()
	icon = null
	
	if !pose:
		return
	
	custom_minimum_size = Vector2(0, height)
	
	icon = TextureRect.new()
	
	add_child(icon, true)
	icon.owner = get_tree().edited_scene_root

	icon.name = "Icon"
	
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	icon.texture = pose.icon
	icon.modulate = pose.color
	
	icon.size = Vector2(height, height)
	
	icon.layout_mode = 1
	icon.anchors_preset = Control.PRESET_CENTER_LEFT
	
	for i in slot_count:
		var rect = TextureRect.new()
		add_child(rect, true)
		rect.owner = get_tree().edited_scene_root
		slots.append(rect)
		
		rect.name = "Slot %s" % (i + 1)
		
		rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		rect.texture = slot_texture
		rect.modulate = pose.color
		
		rect.size = Vector2(height, height)
		
		rect.layout_mode = 1
		rect.anchors_preset = Control.PRESET_CENTER_LEFT
