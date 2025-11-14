extends Node3D

class_name DebateBackgroundAngle

signal on_tween_completed

@onready var start_angle: PhantomCamera3D = $StartAngle
@onready var end_angle: PhantomCamera3D = $EndAngle

# Called when the node enters the scene tree for the first time.
func _ready():
	start_angle.tween_resource.duration = 0

func start_tween():
	start_angle.priority = 1
	await start_angle.tween_completed
	_tween_to_end_angle()

func _tween_to_end_angle():
	start_angle.priority = 0
	end_angle.priority = 1
	await end_angle.tween_completed
	end_angle.priority = 0
	on_tween_completed.emit()
	
