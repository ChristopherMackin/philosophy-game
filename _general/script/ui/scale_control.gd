@tool
extends Node

class_name ScaleControl

@export_tool_button("Test", "Play") var btn_test:
	get: return animate_scale
	
@export var target: Control
@export var curve: Curve
@export var seconds: float
var miliseconds: float:
	get: return seconds * 1000
@export var reset_on_animation_finished: bool = true

var is_running: bool = false
var canceled: bool = false

signal cancel
signal scaling_finished

func animate_scale():
	if canceled: return
	
	if is_running:
		canceled = true
		cancel.emit()
		canceled = false
		
	_animate_scale()

func _animate_scale():
	is_running = true
	var original_scale: Vector2 = target.scale
	var start_time = Time.get_ticks_msec()
	
	while Time.get_ticks_msec() - start_time < miliseconds && !canceled:
		target.scale = original_scale * curve.sample((Time.get_ticks_msec() - start_time)/ miliseconds)
		await Util.await_any([
			func(): await get_tree().process_frame,
			func(): await cancel
		])
	
	target.scale = original_scale * curve.sample((Time.get_ticks_msec() - start_time)/ miliseconds)
	
	if reset_on_animation_finished: target.scale = original_scale
	scaling_finished.emit()
	is_running = false
