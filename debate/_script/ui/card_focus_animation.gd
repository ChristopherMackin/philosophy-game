extends Node

class_name CardFocusAnimation

var initial_position: Vector2

@export var card_base: Control
@export var tween_speed: float = .2
@export var move_up_amount: float = 150
@export var gyro:= false

var pos_tween: Tween:
	set(val):
		Util.optional_disconnect(pos_tween, "finished", destroy_tween)
		pos_tween = val
		Util.optional_connect(pos_tween, "finished", destroy_tween)

@export_category("Shake")
@export var shake_intensity: float = 10.0
@export var shake_duration: float = 0.3
@export var shake_count: int = 8

func _ready():
	initial_position = card_base.position

func _process(delta):
	if !gyro: card_base.rotation_degrees = 0
	else: card_base.rotation_degrees = 0 - rad_to_deg(card_base.get_parent_control().get_global_transform_with_canvas().basis_xform(Vector2.RIGHT).angle())

func destroy_tween():
	pos_tween = null

func shake() -> void:
	if pos_tween: await pos_tween.finished
	
	var original_pos: Vector2 = card_base.position
	pos_tween = create_tween()
	var interval = shake_duration / shake_count
	
	for i in range(shake_count):
		var random_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		# On the last step, return to original position
		var target_pos = original_pos + random_offset if i < shake_count - 1 else original_pos
		pos_tween.tween_property(card_base, "position", target_pos, interval)
		
	# Ensure it settles back perfectly
	pos_tween.tween_property(card_base, "position", original_pos, interval)

func _on_focus_entered():
	gyro = true
	if pos_tween: pos_tween.kill()
	pos_tween = _get_tween()
	pos_tween.tween_property(card_base, "position", initial_position + Vector2(0, -move_up_amount), tween_speed)
	
	card_base.set_z_index(1)

func _on_focus_exited():
	gyro = false
	if pos_tween: pos_tween.kill()
	pos_tween = _get_tween()
	pos_tween.tween_property(card_base, "position", initial_position, tween_speed)
	
	card_base.set_z_index(0)

func _get_tween() -> Tween:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	return tween
