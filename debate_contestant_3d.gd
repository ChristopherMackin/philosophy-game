extends Node3D

class_name DebateContestant3D

@export var emotion_index : int:
	set(val):
		emotion_index = val
		(func ():
			facial_animator.emotion_index = emotion_index
			).call_deferred()

@export var facial_animator : FacialAnimator

@export_group("Prefabs")
@export var top_3d_prefab : PackedScene
@export var top_card_3d_prefab : PackedScene

@export_group("Tops")
@export var discard : Discard3D
@export var tops_board : TopsBoard3D

@export var max_random_rotation_degrees : float
@export var play_duration : float = 1

@export_group("Dialogue")
@export var spawn_location : Node
@export var default_bubble_prefab : PackedScene
@export var emotion_index_prefabs : Array[EmotionIndexPrefab]
var current_dialogue_bubble : DialogueBubble

func get_random_rotation_rad():
	var angle = randf_range(0, max_random_rotation_degrees)
	var angle_rad = deg_to_rad(angle)
	var sign : bool = randi_range(0, 1) == 0
	
	return angle_rad if sign else -angle_rad

func play_top(top : Top):
	
	#Discard top card
	var top_card : TopCard = top_card_3d_prefab.instantiate() as TopCard
	discard.add_child(top_card)
	
	top_card.top = top
	#This will be replaced with a more suitable procedural animation 
	top_card.global_position = global_position + Vector3(0, 1, 0)
	top_card.rotation.z = get_random_rotation_rad()
	
	var card_tween = get_tree().create_tween().tween_property(top_card, "global_position", discard.global_position + Vector3(0, .001, 0) * discard.get_child_count(), play_duration)
	await card_tween.finished
	
	#Play top on board
	var top_3d : Top3D = top_3d_prefab.instantiate()
	var track = tops_board.get_pose_track(top)
	get_tree().root.add_child(top_3d)
	top_3d.reparent(track, true)
	
	top_3d.set_top_texture(top)
	#This will be replaced with a more suitable procedural animation 
	top_3d.global_position = global_position + Vector3(0, 1, 0)

	var top_tween = get_tree().create_tween().tween_property(top_3d, "global_position", track.get_top_slot().global_position + Vector3(0,.002,0), play_duration)
	track.tops_3d.append(top_3d)
	await top_tween.finished

func say_line(line : String, await_input : bool):
	if await_input:
		await create_bubble(line)
	else:
		create_bubble(line)

func create_bubble(line):
	current_dialogue_bubble = default_bubble_prefab.instantiate()
	spawn_location.add_child(current_dialogue_bubble)
	
	facial_animator.mouth_state = FacialAnimator.MouthState.TALKING
	await current_dialogue_bubble.set_text(line)
	facial_animator.mouth_state = FacialAnimator.MouthState.CLOSED
	
	
	current_dialogue_bubble.queue_free()

func _input(event):
	if !current_dialogue_bubble:
		return;
	
	if event.is_action_pressed("cancel"):
		current_dialogue_bubble.skip_to_the_end()
		
	if event.is_action_pressed("select"):
		current_dialogue_bubble.set_speed_to_quick()
	elif event.is_action_released("select"):
		current_dialogue_bubble.set_speed_to_normal()
