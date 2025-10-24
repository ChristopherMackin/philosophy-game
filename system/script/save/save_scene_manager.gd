extends Node

class_name SaveSceneManager

@export var save_data_list : Array[SaveData]

func _enter_tree():
	load_data()
	SceneManager.on_scene_unloaded.connect(save_data, CONNECT_ONE_SHOT)

func load_data():
	for data : SaveData in save_data_list:
		if data.should_load_data && !SaveDataGlobalList.loaded_data.has(data.resource):
			data.load_data()
			SaveDataGlobalList.loaded_data.append(data.resource)

func save_data():
	for data : SaveData in save_data_list:
		if data.should_save_data:
			data.save_data()
