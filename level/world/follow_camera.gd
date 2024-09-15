@tool
extends Camera3D

@export var follow_transform : Node3D
@export var offset : Vector3 = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !follow_transform:
		return;
	
	position = follow_transform.position + offset
