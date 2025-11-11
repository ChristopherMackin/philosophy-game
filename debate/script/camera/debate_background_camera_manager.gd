extends Node

@export var angles: Array[DebateBackgroundAngle]
@export var amount_to_cache:= 3
var cached_indexes: Array[int]

func _ready():
	if amount_to_cache > angles.size() - 1: amount_to_cache = angles.size() - 1
	_change_camera()

func _change_camera():
	var index = randi_range(0, angles.size() - 1)
	while cached_indexes.has(index):
		index += 1
		index %= angles.size() - 1
	
	var angle:= angles[index]
	angle.start_tween()
	await angle.on_tween_completed
	
	cached_indexes.append(index)
	if cached_indexes.size() >= amount_to_cache:
		cached_indexes.pop_front()
	
	_change_camera()
	
