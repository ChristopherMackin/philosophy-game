extends Node

class_name SaveManager

@export var databases : Array[StateDatabase]

func _enter_tree():
	for d : StateDatabase in databases:
		d.load_database()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		for d : StateDatabase in databases:
			d.save_database()
