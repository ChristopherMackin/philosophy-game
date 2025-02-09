extends Node

class_name SaveManager

@export var save_data : Array[SaveData]

func _enter_tree():
	for data : SaveData in save_data:
		data.load_data()

func _notification(what):
	for data : SaveData in save_data:
		data.save_data()
