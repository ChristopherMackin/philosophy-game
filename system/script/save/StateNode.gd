class_name StateNode
extends Node

@export var node_list: Array[Node]
@export var properties: Array[String] = []

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_state()

func save_state():
	for node in node_list:
		_save_node_in_global_blackboard(node)

func load_state():
	for node in node_list:
		_load_node_from_global_blackboard(node)

func _save_node_in_global_blackboard(node: Node):
	var dictionary = {}
	
	for property in properties:
		if property in node:
			dictionary[property] = node.get(property)
	
	Global.blackboard.add(node.get_path(), dictionary)

func _load_node_from_global_blackboard(node: Node):
	if !Global.blackboard.has(node.get_path()): return
	
	var dictionary = Global.blackboard.get_value(node.get_path())
	
	for key in dictionary:
		if key in node:
			node.set(key, dictionary[key])
