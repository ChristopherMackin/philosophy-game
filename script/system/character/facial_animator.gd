extends Node3D

class_name FacialAnimator

@export var eyes : MeshInstance3D
var eye_material : Material

@export var mouth : MeshInstance3D

var timer : float = 0
var blink_offset : float

@export var min_blink_offset : float = .5
@export var max_blink_offset : float = 2

@export var blink_length : float = .1

func _ready():
	eye_material = eyes.mesh.surface_get_material(0)
	blink_offset = get_random_blink_offset()

func _process(delta):
	timer += delta
	
	if timer >= blink_offset:
		blink()
		timer = 0
		blink_offset = get_random_blink_offset()

func blink():
	eye_material.uv1_offset = Vector3(.25, 0, 0)
	await GlobalTimer.wait_for_seconds(blink_length)
	eye_material.uv1_offset = Vector3.ZERO

func get_random_blink_offset() -> float :
	return randf_range(min_blink_offset, max_blink_offset)
