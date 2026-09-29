@tool
class_name StateNode
extends Node

@export var node_list: Array[Node]
@export var properties: Array[String] = []
@export var expiration_flags: int = 0

# This function builds the inspector interface dynamically
func _validate_property(property: Dictionary) -> void:
	if property.name == "expiration_flags":
		property.hint = PROPERTY_HINT_FLAGS
		property.hint_string = ",".join(Blackboard.ExpirationToken.keys()) # Automatically maps keys to checkboxes

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
	
	Global.blackboard.add(node.get_path(), dictionary, expiration_flags)

func _load_node_from_global_blackboard(node: Node):
	if !Global.blackboard.has(node.get_path()): return
	
	var dictionary = Global.blackboard.get_value(node.get_path())
	
	for key in dictionary:
		if key in node:
			node.set(key, dictionary[key])
