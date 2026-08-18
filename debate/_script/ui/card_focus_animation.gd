extends Node

class_name CardFocusAnimation

@export var card_base: CardGUI
@export var tween_speed: float = .2
@export var gyro:= false

var pos_tween: Tween

func _process(delta):
	if !gyro: card_base.rotation_degrees = 0
	else: card_base.rotation_degrees = 0 - rad_to_deg(card_base.get_parent_control().get_global_transform_with_canvas().basis_xform(Vector2.RIGHT).angle())

func _on_focus_entered():
	gyro = true
	if pos_tween: pos_tween.kill()
	pos_tween = _get_tween()
	pos_tween.tween_property(card_base, "position", Vector2(0, -100), tween_speed)
	
	card_base.set_z_index(1)

func _on_focus_exited():
	gyro = false
	if pos_tween: pos_tween.kill()
	pos_tween = _get_tween()
	pos_tween.tween_property(card_base, "position", (Vector2.ZERO), tween_speed)
	
	card_base.set_z_index(0)

func _get_tween() -> Tween:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	return tween
