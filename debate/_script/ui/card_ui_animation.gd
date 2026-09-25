extends Node

class_name CardUiAnimation

var initial_position: Vector2

@export_group("Dependencies")
@export var card_base: Control

@export_group("Animation")
@export var gyro:= false

@export_category("Focus")
@export var focus_tween_speed: float = .2
@export var focus_move_amount: Vector2 = Vector2(0, -150)

@export_category("Play")
@export var play_tween_speed: float = .6
@export var play_pause_length: float = .2
@export var fade_tween_speed: float = 1
@export var play_move_amount: Vector2 = Vector2(0, -300)

@export_category("Shake")
@export var shake_intensity: float = 10.0
@export var shake_duration: float = 0.3
@export var shake_count: int = 8

var tween: Tween:
	set(val):
		Util.optional_disconnect(tween, "finished", destroy_tween)
		tween = val
		Util.optional_connect(tween, "finished", destroy_tween)

func _ready():
	initial_position = card_base.position

func _process(delta):
	if !gyro: card_base.rotation_degrees = 0
	else: card_base.rotation_degrees = 0 - rad_to_deg(card_base.get_parent_control().get_global_transform_with_canvas().basis_xform(Vector2.RIGHT).angle())

func destroy_tween():
	tween = null

func shake() -> void:
	if tween: await tween.finished
	
	var original_pos: Vector2 = card_base.position
	tween = create_tween()
	var interval = shake_duration / shake_count
	
	for i in range(shake_count):
		var random_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		# On the last step, return to original position
		var target_pos = original_pos + random_offset if i < shake_count - 1 else original_pos
		tween.tween_property(card_base, "position", target_pos, interval)
		
	# Ensure it settles back perfectly
	tween.tween_property(card_base, "position", original_pos, interval)

func on_card_updated():
	shake()

func on_card_removed():
	print("CARD REMOVED")

func on_card_played():
	gyro = true
	if tween: tween.kill()
	
	card_base.set_z_index(0)
	card_base.modulate = Color(.7,.7,.7)
	
	tween = _get_tween()
	tween.tween_property(card_base, "global_position", card_base.global_position + play_move_amount, play_tween_speed)
	
	await tween.finished
	
	await GlobalTimer.wait_for_seconds(play_pause_length)
	
	tween = _get_tween()
	tween.tween_property(card_base, "modulate", Color(.7,.7,.7,0), fade_tween_speed)
	
	await tween.finished

func on_card_held():
	print("HOLD CARD")

func _on_focus_entered():
	gyro = true
	if tween: tween.kill()
	tween = _get_tween()
	tween.tween_property(card_base, "position", initial_position + focus_move_amount, focus_tween_speed)
	
	card_base.set_z_index(1)

func _on_focus_exited():
	gyro = false
	if tween: tween.kill()
	tween = _get_tween()
	tween.tween_property(card_base, "position", initial_position, focus_tween_speed)
	
	card_base.set_z_index(0)

func _get_tween() -> Tween:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	return tween
