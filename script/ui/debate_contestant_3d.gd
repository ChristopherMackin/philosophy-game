extends Node3D

class_name DebateContestant3D

@export var emotion_index : int:
	set(val):
		emotion_index = val
		(func ():
			facial_animator.emotion_index = emotion_index
			).call_deferred()

@export var facial_animator : FacialAnimator

@export var max_random_rotation_degrees : float
@export var play_duration : float = 1

func get_random_rotation_rad():
	var angle = randf_range(0, max_random_rotation_degrees)
	var angle_rad = deg_to_rad(angle)
	var sign : bool = randi_range(0, 1) == 0
	
	return angle_rad if sign else -angle_rad
