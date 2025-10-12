extends Area3D

class_name CameraAngleTrigger

@export var angle: PhantomCamera3D

var _previous_priority: int
@export var _priority: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_set_as_priority.unbind(1))
	body_exited.connect(_unset_as_priority.unbind(1))

func _set_as_priority():
	_previous_priority = angle.priority
	angle.priority = _priority

func _unset_as_priority():
	angle.priority = _previous_priority
