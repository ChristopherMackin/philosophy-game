extends Node

func _input(event):
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_SPACE:
			Global.save_state_with_meta_tag()
			print("state saved")
