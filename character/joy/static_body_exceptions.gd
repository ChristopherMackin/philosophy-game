extends StaticBody3D

@export var exceptions: Array[CollisionObject3D]

# Called when the node enters the scene tree for the first time.
func _ready():
	for exception in exceptions:
		add_collision_exception_with(exception)
