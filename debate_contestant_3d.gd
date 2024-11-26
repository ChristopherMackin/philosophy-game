extends Node3D

class_name DebateContestant3D

signal on_stop_dialogue

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
@export var default_dialogue_bubble : DialogueBubble

func _ready():
	default_dialogue_bubble.visible = false
	default_dialogue_bubble.on_stop_dialogue.connect(stop_dialogue)

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

func start_dialogue(line : String):
	facial_animator.mouth_state = FacialAnimator.MouthState.TALKING
	default_dialogue_bubble.visible = true
	default_dialogue_bubble.set_text(line)

func stop_dialogue():
	default_dialogue_bubble.stop_scrolling()
	facial_animator.mouth_state = FacialAnimator.MouthState.CLOSED
	default_dialogue_bubble.visible = false
	on_stop_dialogue.emit()
