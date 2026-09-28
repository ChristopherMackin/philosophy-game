class_name StateNode
extends Node

@export var root: Node
@export var properties: Array[String] = []
@export var recursive:= false

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
			save_state()

func save_state():
	_save_node_in_global_blackboard(root)
	
	if recursive:
		for child in Util.get_all_children(root):
			_save_node_in_global_blackboard(child)

func load_state():
	_load_node_from_global_blackboard(root)
	
	if recursive:
		for child in Util.get_all_children(root):
			_load_node_from_global_blackboard(child)

func _save_node_in_global_blackboard(node: Node):
	var dictionary = {}
	
	for property in properties:
		if property in node:
			dictionary[property] = node.get(property)
	
	Global.blackboard.add(node.get_path(), dictionary)
	
	print("Saved %s in global blackboard" % node.get_path())

func _load_node_from_global_blackboard(node: Node):
	if !Global.blackboard.has(node.get_path()): return
	
	var dictionary = Global.blackboard.get_value(node.get_path())
	
	for key in dictionary:
		if key in node:
			node.set(key, dictionary[key])
	
	print("Loaded %s from global blackboard" % node.get_path())
