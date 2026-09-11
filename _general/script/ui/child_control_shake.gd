@tool
extends Control

class_name  ChildControlShake

@export var shake_strength: float = 0.0
@export var shake_fade: float = 5.0

func _process(delta: float) -> void:	
	if get_child_count() <= 0: return
	
	var shake_root = get_child(0)
	
	if !shake_root is Control: return
	
	if shake_strength > 0:
		shake_strength = max(0.0, shake_strength - shake_fade * delta)
		shake_root.position = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		shake_root.position = Vector2.ZERO
