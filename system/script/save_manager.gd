extends Node

class_name SaveManager
static var _loaded_data_list: Array[SaveData]

@export var save_data : bool = true
@export var load_data : bool = true
@export var save_data_list : Array[SaveData]

func _enter_tree():
	SceneManager.on_scene_unload.connect(_save_data)
	
	if !load_data: return
		
	for data : SaveData in save_data_list:
		if !_loaded_data_list.has(data):
			data.load_data()
			_loaded_data_list.append(data)

func _save_data():
	if !save_data: return
	
	for data : SaveData in save_data_list:
			data.save_data()
