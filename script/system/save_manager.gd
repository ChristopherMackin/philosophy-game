extends Node

class_name SaveManager
static var _loaded_data_list: Array[SaveData]

@export var save_data : bool = true
@export var load_data : bool = true
@export var save_data_list : Array[SaveData]

func _enter_tree():
	if !load_data: return
		
	for data : SaveData in save_data_list:
		if !_loaded_data_list.has(data):
			data.load_data()
			_loaded_data_list.append(data)

func _notification(what):
	if !save_data: return
	
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_EXIT_TREE:
		for data : SaveData in save_data_list:
			data.save_data()
