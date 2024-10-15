extends Node3D

class_name FacialAnimator

enum FaceState {
	OPEN = 0,
	CLOSED = 1,
	BLINKING = 2,
}

@export var face_state : FaceState = FaceState.BLINKING:
	set(val):
		face_state = val
		set_face_material_uv_offset.call_deferred()

func set_face_material_uv_offset():
	var uv_offset : Vector3
	
	if face_state == FaceState.BLINKING:
		uv_offset = get_uv_offset(0, FaceState.OPEN)
	else:
		uv_offset = get_uv_offset(0, face_state)

	face_material.uv1_offset = uv_offset

@export var face : MeshInstance3D
var face_material : Material

var blink_timer : float = 0
var blink_offset : float

@export var min_blink_offset : float = .5
@export var max_blink_offset : float = 2

@export var blink_length : float = .1

enum MouthState {
	CLOSED = 0,
	OPEN = 1,
	TALKING = 2
}

@export var mouth_state : MouthState = MouthState.CLOSED:
	set(val):
		mouth_state = val
		set_mouth_material_uv_offset.call_deferred()

func set_mouth_material_uv_offset():
	var uv_offset : Vector3
	
	if mouth_state == MouthState.TALKING:
		uv_offset = get_uv_offset(0, MouthState.OPEN)
	else:
		uv_offset = get_uv_offset(0, mouth_state)

	mouth_material.uv1_offset = uv_offset

@export var mouth : MeshInstance3D
var mouth_material : Material

@export var talk_speed : float = 2

func _ready():
	face_material = face.mesh.surface_get_material(0)
	mouth_material = mouth.mesh.surface_get_material(0)
	blink_offset = get_random_blink_offset()

func _process(delta):
	if face_state == FaceState.BLINKING:
		blink(delta)
	if mouth_state == MouthState.TALKING:
		talk(delta)

func blink(delta):
	blink_timer += delta
	
	if blink_timer >= blink_offset:
		face_material.uv1_offset = get_uv_offset(0, FaceState.CLOSED)
		await GlobalTimer.wait_for_seconds(blink_length)
		if face_state == FaceState.BLINKING:
			face_material.uv1_offset = get_uv_offset(0, FaceState.OPEN)
		
		blink_timer = 0
		blink_offset = get_random_blink_offset()

func talk(delta):
	
	if(sin(Time.get_unix_time_from_system() * talk_speed) > 0):
		mouth_material.uv1_offset = get_uv_offset(0, MouthState.OPEN)
	else:
		mouth_material.uv1_offset = get_uv_offset(0, MouthState.CLOSED)

func get_random_blink_offset() -> float :
	return randf_range(min_blink_offset, max_blink_offset)

#This works only on a 8 emotion tile set with two states for each emotion
func get_uv_offset(index : int, state) -> Vector3:
	if index < 0 || index >= 8:
		return Vector3.ZERO

	return Vector3((index % 2) * .5 + state * .25, floorf( index / 8.0 ), 0)
