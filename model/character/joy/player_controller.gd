extends CharacterBody3D

@export var speed = 5.0
@export var acceleration = 4.0
@export var rotation_speed = 12.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var armature = $Armature
@onready var animation_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	velocity.y += -gravity * delta
	get_move_input(delta)

	move_and_slide()
	
	if velocity.length() > 1.0:
		var vec_2 = Vector2(-velocity.x, velocity.z)
		armature.rotation.y = lerp_angle(armature.rotation.y, vec_2.angle() + deg_to_rad(90), rotation_speed * delta)

func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "up", "down")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, get_viewport().get_camera_3d().rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	var vec_2 = Vector2(-velocity.x, velocity.z)
	animation_tree.set("parameters/IdleWalk/blend_position", vec_2.length() / speed)
	
	velocity.y = vy

func _unhandled_input(event):
	if event.is_action_pressed("kick"):
		anim_state.travel("Kick")
