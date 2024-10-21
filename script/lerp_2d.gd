extends Node

class_name Lerp2D

signal finished

var _parent

var starting_pos : Vector2
var target_pos : Vector2

var timer : float = 0
@export var duration : float = 2

func _enter_tree():
	_parent = get_parent()

func _process(delta):
	timer += delta
	
	var pos = starting_pos.lerp(target_pos, timer / duration) if timer < duration else target_pos
	
	_parent.position = pos
	
	if timer >= duration:
		finished.emit()
		queue_free()
