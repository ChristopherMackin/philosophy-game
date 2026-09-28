extends Node

class_name SaveSceneManager

@export var save_data_list : Array[SaveData]
@export var save_on_project_stop := false

func _enter_tree():
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_data()

func load_data():
	for data : SaveData in save_data_list:
		if !SaveDataGlobalList.loaded_data.has(data.resource):
			if data.should_load_data:
				data.load_data()
			SaveDataGlobalList.loaded_data.append(data.resource)

func save_data():
	for data : SaveData in save_data_list:
		if data.should_save_data:
			data.save_data()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if save_on_project_stop:
			save_data()
		
		await Global.wait_for_seconds(.5)
		
		get_tree().quit()
