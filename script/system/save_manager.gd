extends Node

class_name SaveManager

@export var should_save_data : bool = true
@export var save_data : Array[SaveData]

func _enter_tree():
	if !should_save_data: return
	
	for data : SaveData in save_data:
		data.load_data()

func _notification(what):
	if !should_save_data: return
	
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_EXIT_TREE:
		for data : SaveData in save_data:
			data.save_data()
