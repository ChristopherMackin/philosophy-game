extends CharacterBody3D

class_name CharacterBody

@export_group("Dependency")
@export var camera: Camera3D
@export var character_actor : CharacterActor
@export var character_animator: CharacterAnimationTree

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0

var last_movement_direction:= Vector3.BACK

func _physics_process(delta):
	
	var direction: Vector3
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	else:
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		var camera_basis := camera.global_basis
		camera_basis.y = Vector3.ZERO
		
		direction = (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction.y = 0
		
		var target_direction = direction
		
		if direction.length() < 0.2:
			lerp(velocity, direction, delta * rotation_speed)
			target_direction = target_direction.normalized()
		
		velocity = velocity.move_toward(target_direction * move_speed, acceleration * delta)

	move_and_slide()
	
	if direction.length() > 0.2:
		character_actor.global_rotation.y = Vector3.BACK.signed_angle_to(velocity, Vector3.UP)
	
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.3)
			col.get_collider().apply_impulse(-col.get_normal() * 0.01, col.get_position())
	
	var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
	character_animator.set("parameters/walking/blend_amount", clamp(horizontal_velocity.length(), 0, 1))
